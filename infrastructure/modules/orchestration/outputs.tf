output "workflow_id" {
  description = "ID of the main orchestration workflow"
  value       = google_workflows_workflow.estudio_vertice_pipeline.id
}

output "workflow_name" {
  description = "Name of the main orchestration workflow"
  value       = google_workflows_workflow.estudio_vertice_pipeline.name
}

output "pubsub_topic" {
  description = "Pub/Sub topic for triggering workflows"
  value       = google_pubsub_topic.video_creation_trigger.name
}

output "service_account_email" {
  description = "Email of the workflow service account"
  value       = google_service_account.workflow_sa.email
}