output "main_bucket_name" {
  description = "Name of the main storage bucket"
  value       = google_storage_bucket.main.name
}

output "input_bucket_name" {
  description = "Name of the input bucket"
  value       = google_storage_bucket.input.name
}

output "processed_bucket_name" {
  description = "Name of the processed content bucket"
  value       = google_storage_bucket.processed.name
}

output "videos_bucket_name" {
  description = "Name of the videos bucket"
  value       = google_storage_bucket.videos.name
}

output "models_bucket_name" {
  description = "Name of the models bucket"
  value       = google_storage_bucket.models.name
}

output "analytics_bucket_name" {
  description = "Name of the analytics bucket"
  value       = google_storage_bucket.analytics.name
}

output "terraform_state_bucket_name" {
  description = "Name of the terraform state bucket"
  value       = google_storage_bucket.terraform_state.name
}