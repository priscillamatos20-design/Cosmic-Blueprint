# Vertex AI Dataset for training custom models
resource "google_vertex_ai_dataset" "kurzgesagt_training_data" {
  display_name          = "${var.environment}-kurzgesagt-training-dataset"
  metadata_schema_uri   = "gs://google-cloud-aiplatform/schema/dataset/metadata/text_1.0.0.yaml"
  region               = var.region
  project              = var.project_id
  
  labels = {
    environment = var.environment
    purpose     = "kurzgesagt_methodology_training"
    version     = "4.1"
  }
}

# Custom training job for Kurzgesagt-specific models
resource "google_vertex_ai_training_pipeline" "kurzgesagt_model_training" {
  display_name         = "${var.environment}-kurzgesagt-model-training"
  location            = var.region
  project             = var.project_id
  
  training_task_definition = jsonencode({
    "trainingTaskDefinition": {
      "containerSpec": {
        "imageUri": "gcr.io/${var.project_id}/kurzgesagt-trainer:latest",
        "command": ["python", "train_kurzgesagt_model.py"],
        "args": [
          "--training-data-path", "gs://${var.storage_bucket}/training-data/",
          "--model-output-path", "gs://${var.storage_bucket}/models/",
          "--methodology-version", "4.1"
        ]
      },
      "machineSpec": {
        "machineType": "n1-standard-4",
        "acceleratorType": "NVIDIA_TESLA_T4",
        "acceleratorCount": 1
      }
    }
  })
  
  model_to_upload {
    display_name = "${var.environment}-kurzgesagt-success-predictor"
  }
  
  input_data_config {
    dataset_id = google_vertex_ai_dataset.kurzgesagt_training_data.name
  }
  
  depends_on = [google_vertex_ai_dataset.kurzgesagt_training_data]
}

# Vertex AI Endpoint for serving predictions
resource "google_vertex_ai_endpoint" "success_prediction_endpoint" {
  name         = "${var.environment}-success-prediction-endpoint"
  display_name = "Kurzgesagt Success Prediction Endpoint"
  location     = var.region
  project      = var.project_id
  
  labels = {
    environment = var.environment
    model_type  = "success_prediction"
    methodology = "kurzgesagt_quantified"
  }
}

# BigQuery dataset for analytics and data warehousing
resource "google_bigquery_dataset" "estudio_vertice_analytics" {
  dataset_id                  = "${replace(var.environment, "-", "_")}_estudio_vertice_analytics"
  friendly_name              = "Estúdio Vértice Analytics"
  description                = "Dataset para analytics e métricas do Estúdio Vértice"
  location                   = "US"
  project                    = var.project_id
  default_table_expiration_ms = 7776000000 # 90 days

  labels = {
    environment = var.environment
    purpose     = "analytics"
  }
}

# BigQuery tables for different data types
resource "google_bigquery_table" "video_performance_metrics" {
  dataset_id = google_bigquery_dataset.estudio_vertice_analytics.dataset_id
  table_id   = "video_performance_metrics"
  project    = var.project_id

  schema = jsonencode([
    {
      name = "video_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "created_at"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "processing_time_seconds"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "cost_usd"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "quality_score"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "predicted_success_score"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "actual_views"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "actual_engagement_rate"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "kurzgesagt_compliance_score"
      type = "FLOAT"
      mode = "NULLABLE"
    }
  ])
}

resource "google_bigquery_table" "content_analysis_data" {
  dataset_id = google_bigquery_dataset.estudio_vertice_analytics.dataset_id
  table_id   = "content_analysis_data"
  project    = var.project_id

  schema = jsonencode([
    {
      name = "content_id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "analyzed_at"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    },
    {
      name = "hook_potential"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "complexity_level"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "key_concepts"
      type = "STRING"
      mode = "REPEATED"
    },
    {
      name = "scientific_accuracy"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "nihilistic_optimism_balance"
      type = "FLOAT"
      mode = "NULLABLE"
    }
  ])
}

# AutoML model for content classification
resource "google_vertex_ai_dataset" "content_classification_dataset" {
  display_name          = "${var.environment}-content-classification-dataset"
  metadata_schema_uri   = "gs://google-cloud-aiplatform/schema/dataset/metadata/text_1.0.0.yaml"
  region               = var.region
  project              = var.project_id
}

# Cloud Storage bucket for ML model artifacts
resource "google_storage_bucket" "ml_models" {
  name          = "${var.environment}-estudio-vertice-ml-models"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

# Dataflow job for real-time data processing
resource "google_dataflow_job" "real_time_analytics" {
  name              = "${var.environment}-estudio-vertice-analytics"
  template_gcs_path = "gs://dataflow-templates/latest/PubSub_to_BigQuery"
  temp_gcs_location = "gs://${var.storage_bucket}/dataflow-temp/"
  project           = var.project_id
  region            = var.region
  
  parameters = {
    inputTopic      = "projects/${var.project_id}/topics/${var.environment}-video-metrics"
    outputTableSpec = "${var.project_id}:${google_bigquery_dataset.estudio_vertice_analytics.dataset_id}.video_performance_metrics"
  }
  
  depends_on = [
    google_bigquery_table.video_performance_metrics
  ]
}

# Pub/Sub topics for real-time data streaming
resource "google_pubsub_topic" "video_metrics" {
  name    = "${var.environment}-video-metrics"
  project = var.project_id
}

resource "google_pubsub_topic" "content_analysis_results" {
  name    = "${var.environment}-content-analysis-results"
  project = var.project_id
}

resource "google_pubsub_topic" "quality_assessments" {
  name    = "${var.environment}-quality-assessments"
  project = var.project_id
}

# AI Platform Notebooks for data science and experimentation
resource "google_notebooks_instance" "kurzgesagt_research" {
  name         = "${var.environment}-kurzgesagt-research"
  location     = "${var.region}-b"
  project      = var.project_id
  machine_type = "n1-standard-4"

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-2-11-cpu"
  }

  disk_encryption = "CMEK"
  disk_size_gb    = 100
  disk_type       = "PD_STANDARD"

  labels = {
    environment = var.environment
    purpose     = "kurzgesagt_research"
  }
}

# Cloud Scheduler for periodic model retraining
resource "google_cloud_scheduler_job" "model_retraining" {
  name      = "${var.environment}-model-retraining"
  region    = var.region
  project   = var.project_id
  schedule  = "0 2 * * 0" # Every Sunday at 2 AM
  time_zone = "UTC"

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-${var.project_id}.cloudfunctions.net/trigger-model-retraining"
    
    headers = {
      "Content-Type" = "application/json"
    }
    
    body = base64encode(jsonencode({
      "dataset_id": google_vertex_ai_dataset.kurzgesagt_training_data.name,
      "model_type": "kurzgesagt_success_predictor",
      "trigger_type": "scheduled_retraining"
    }))
  }
}

# Secret Manager for storing API keys and sensitive configuration
resource "google_secret_manager_secret" "api_keys" {
  secret_id = "${var.environment}-estudio-vertice-api-keys"
  project   = var.project_id

  labels = {
    environment = var.environment
    purpose     = "api_keys"
  }

  replication {
    automatic = true
  }
}

# Cloud Function for custom model predictions
resource "google_cloudfunctions2_function" "custom_predictions" {
  name     = "${var.environment}-custom-predictions"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "predict"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/custom-predictions.zip"
      }
    }
  }

  service_config {
    max_instance_count = 10
    min_instance_count = 1
    available_memory   = "1Gi"
    timeout_seconds    = 300
    
    environment_variables = {
      ENVIRONMENT     = var.environment
      PROJECT_ID      = var.project_id
      MODEL_ENDPOINT  = google_vertex_ai_endpoint.success_prediction_endpoint.name
      STORAGE_BUCKET  = var.storage_bucket
    }
  }
}