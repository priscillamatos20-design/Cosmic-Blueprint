output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "The GCP region"
  value       = var.region
}

output "cloud_functions_urls" {
  description = "URLs of deployed Cloud Functions"
  value = {
    content_analyzer     = module.workers.content_analyzer_url
    script_generator     = module.workers.script_generator_url
    visual_designer      = module.workers.visual_designer_url
    audio_synthesizer    = module.workers.audio_synthesizer_url
    quality_assurer      = module.workers.quality_assurer_url
    performance_analyzer = module.workers.performance_analyzer_url
  }
}

output "workflow_id" {
  description = "The ID of the main orchestration workflow"
  value       = module.orchestration.workflow_id
}

output "storage_bucket" {
  description = "Main storage bucket name"
  value       = module.storage.main_bucket_name
}

output "monitoring_dashboard_url" {
  description = "URL of the monitoring dashboard"
  value       = module.monitoring.dashboard_url
}