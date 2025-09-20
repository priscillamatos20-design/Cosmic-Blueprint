output "dataset_id" {
  description = "ID of the Vertex AI training dataset"
  value       = google_vertex_ai_dataset.kurzgesagt_training_data.id
}

output "prediction_endpoint_id" {
  description = "ID of the Vertex AI prediction endpoint"
  value       = google_vertex_ai_endpoint.success_prediction_endpoint.id
}

output "bigquery_dataset_id" {
  description = "BigQuery dataset ID for analytics"
  value       = google_bigquery_dataset.estudio_vertice_analytics.dataset_id
}

output "ml_models_bucket" {
  description = "Bucket for ML model artifacts"
  value       = google_storage_bucket.ml_models.name
}

output "notebooks_instance_name" {
  description = "Name of the AI Platform Notebooks instance"
  value       = google_notebooks_instance.kurzgesagt_research.name
}

output "pubsub_topics" {
  description = "Pub/Sub topics for real-time streaming"
  value = {
    video_metrics         = google_pubsub_topic.video_metrics.name
    content_analysis     = google_pubsub_topic.content_analysis_results.name
    quality_assessments  = google_pubsub_topic.quality_assessments.name
  }
}

output "custom_predictions_function" {
  description = "Custom predictions Cloud Function name"
  value       = google_cloudfunctions2_function.custom_predictions.name
}