# Main orchestration workflow
resource "google_workflows_workflow" "estudio_vertice_pipeline" {
  name          = "${var.environment}-estudio-vertice-pipeline"
  region        = var.region
  project       = var.project_id
  description   = "Pipeline completo do Estúdio Vértice para produção de vídeos educacionais"
  
  source_contents = templatefile("${path.module}/workflow.yaml", {
    project_id = var.project_id
    region     = var.region
    content_analyzer_function     = var.worker_functions.content_analyzer
    script_generator_function     = var.worker_functions.script_generator
    visual_designer_function      = var.worker_functions.visual_designer
    audio_synthesizer_function    = var.worker_functions.audio_synthesizer
    quality_assurer_function      = var.worker_functions.quality_assurer
    performance_analyzer_function = var.worker_functions.performance_analyzer
    storage_bucket = var.storage_bucket
  })
}

# Service account for workflow execution
resource "google_service_account" "workflow_sa" {
  account_id   = "${var.environment}-workflow-sa"
  display_name = "Estúdio Vértice Workflow Service Account"
  project      = var.project_id
}

# IAM bindings for workflow service account
resource "google_project_iam_member" "workflow_sa_cloudfunctions_invoker" {
  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

resource "google_project_iam_member" "workflow_sa_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

resource "google_project_iam_member" "workflow_sa_aiplatform_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

# Workflow trigger - Pub/Sub topic
resource "google_pubsub_topic" "video_creation_trigger" {
  name    = "${var.environment}-video-creation-trigger"
  project = var.project_id
}

# Eventarc trigger for workflow
resource "google_eventarc_trigger" "workflow_trigger" {
  name     = "${var.environment}-video-creation-trigger"
  location = var.region
  project  = var.project_id

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }

  destination {
    workflow = google_workflows_workflow.estudio_vertice_pipeline.id
  }

  transport {
    pubsub {
      topic = google_pubsub_topic.video_creation_trigger.id
    }
  }

  service_account = google_service_account.workflow_sa.email
}