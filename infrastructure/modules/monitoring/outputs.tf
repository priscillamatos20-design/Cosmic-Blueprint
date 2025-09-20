output "dashboard_url" {
  description = "URL of the monitoring dashboard"
  value       = "https://console.cloud.google.com/monitoring/dashboards/custom/${google_monitoring_dashboard.estudio_vertice_dashboard.id}?project=${var.project_id}"
}

output "dashboard_id" {
  description = "ID of the monitoring dashboard"
  value       = google_monitoring_dashboard.estudio_vertice_dashboard.id
}

output "alert_policies" {
  description = "List of alert policy names"
  value = [
    google_monitoring_alert_policy.processing_time_alert.name,
    google_monitoring_alert_policy.quality_score_alert.name,
    google_monitoring_alert_policy.cost_exceeded_alert.name,
    google_monitoring_alert_policy.worker_error_alert.name,
    google_monitoring_alert_policy.critical_errors_alert.name
  ]
}

output "notification_channels" {
  description = "Notification channel names"
  value = {
    email = google_monitoring_notification_channel.email_alerts.name
    slack = google_monitoring_notification_channel.slack_alerts.name
  }
}

output "slo_names" {
  description = "Service Level Objective names"
  value = [
    google_monitoring_slo.processing_time_slo.name,
    google_monitoring_slo.quality_score_slo.name
  ]
}

output "service_name" {
  description = "Monitoring service name"
  value       = google_monitoring_service.estudio_vertice_service.name
}

output "uptime_check_id" {
  description = "Uptime check configuration ID"
  value       = google_monitoring_uptime_check_config.workflow_uptime.uptime_check_id
}