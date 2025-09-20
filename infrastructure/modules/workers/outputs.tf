output "function_names" {
  description = "Names of all worker functions"
  value = {
    content_analyzer     = google_cloudfunctions2_function.content_analyzer.name
    script_generator     = google_cloudfunctions2_function.script_generator.name
    visual_designer      = google_cloudfunctions2_function.visual_designer.name
    audio_synthesizer    = google_cloudfunctions2_function.audio_synthesizer.name
    quality_assurer      = google_cloudfunctions2_function.quality_assurer.name
    performance_analyzer = google_cloudfunctions2_function.performance_analyzer.name
  }
}

output "content_analyzer_url" {
  description = "URL of the content analyzer function"
  value       = google_cloudfunctions2_function.content_analyzer.service_config[0].uri
}

output "script_generator_url" {
  description = "URL of the script generator function"
  value       = google_cloudfunctions2_function.script_generator.service_config[0].uri
}

output "visual_designer_url" {
  description = "URL of the visual designer function"
  value       = google_cloudfunctions2_function.visual_designer.service_config[0].uri
}

output "audio_synthesizer_url" {
  description = "URL of the audio synthesizer function"
  value       = google_cloudfunctions2_function.audio_synthesizer.service_config[0].uri
}

output "quality_assurer_url" {
  description = "URL of the quality assurer function"
  value       = google_cloudfunctions2_function.quality_assurer.service_config[0].uri
}

output "performance_analyzer_url" {
  description = "URL of the performance analyzer function"
  value       = google_cloudfunctions2_function.performance_analyzer.service_config[0].uri
}