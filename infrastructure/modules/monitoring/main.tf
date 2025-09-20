# Monitoring Dashboard for Estúdio Vértice
resource "google_monitoring_dashboard" "estudio_vertice_dashboard" {
  dashboard_json = jsonencode({
    displayName = "Estúdio Vértice - ${title(var.environment)} Dashboard"
    
    mosaicLayout = {
      tiles = [
        {
          width = 6
          height = 4
          widget = {
            title = "Pipeline Performance Overview"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "resource.type=\"cloud_function\" AND resource.labels.function_name=~\"${var.environment}-.*\""
                      aggregation = {
                        alignmentPeriod = "60s"
                        perSeriesAligner = "ALIGN_RATE"
                      }
                    }
                  }
                  plotType = "LINE"
                  targetAxis = "Y1"
                }
              ]
              timeshiftDuration = "0s"
              yAxis = {
                label = "Executions/min"
                scale = "LINEAR"
              }
            }
          }
        },
        {
          width = 6
          height = 4
          widget = {
            title = "Processing Time vs Target"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "resource.type=\"gce_instance\""
                      aggregation = {
                        alignmentPeriod = "300s"
                        perSeriesAligner = "ALIGN_MEAN"
                      }
                    }
                  }
                  plotType = "LINE"
                  targetAxis = "Y1"
                }
              ]
              thresholds = [
                {
                  value = var.target_processing_time_minutes * 60
                  color = "RED"
                  direction = "ABOVE"
                  label = "Target Processing Time"
                }
              ]
            }
          }
        },
        {
          width = 4
          height = 3
          widget = {
            title = "Quality Score Distribution"
            pieChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "resource.type=\"global\""
                    }
                  }
                }
              ]
            }
          }
        },
        {
          width = 4
          height = 3
          widget = {
            title = "Cost per Video"
            scorecard = {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type=\"global\""
                  aggregation = {
                    alignmentPeriod = "3600s"
                    perSeriesAligner = "ALIGN_MEAN"
                  }
                }
              }
              thresholds = [
                {
                  value = var.target_cost_per_video
                  color = "GREEN"
                  direction = "BELOW"
                }
              ]
            }
          }
        },
        {
          width = 4
          height = 3
          widget = {
            title = "Success Prediction Accuracy"
            scorecard = {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type=\"global\""
                }
              }
              sparkChartView = {
                sparkChartType = "SPARK_LINE"
              }
            }
          }
        },
        {
          width = 12
          height = 4
          widget = {
            title = "Worker Function Health"
            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "resource.type=\"cloud_function\""
                      aggregation = {
                        alignmentPeriod = "60s"
                        perSeriesAligner = "ALIGN_RATE"
                        crossSeriesReducer = "REDUCE_SUM"
                        groupByFields = ["resource.labels.function_name"]
                      }
                    }
                  }
                  plotType = "STACKED_AREA"
                }
              ]
            }
          }
        }
      ]
    }
  })
  
  project = var.project_id
}

# Alert Policy for Processing Time Exceeded
resource "google_monitoring_alert_policy" "processing_time_alert" {
  display_name = "${var.environment} - Processing Time Exceeded"
  project      = var.project_id
  
  conditions {
    display_name = "Processing time exceeds ${var.target_processing_time_minutes} minutes"
    
    condition_threshold {
      filter          = "resource.type=\"cloud_function\" AND resource.labels.function_name=~\"${var.environment}-.*\""
      duration        = "300s"
      comparison      = "COMPARISON_GREATER_THAN"
      threshold_value = var.target_processing_time_minutes * 60
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email_alerts.name]
  
  alert_strategy {
    auto_close = "1800s"
  }
  
  severity = "ERROR"
}

# Alert Policy for Quality Score Below Target
resource "google_monitoring_alert_policy" "quality_score_alert" {
  display_name = "${var.environment} - Quality Score Below Target"
  project      = var.project_id
  
  conditions {
    display_name = "Quality score below ${var.target_quality_score}"
    
    condition_threshold {
      filter          = "resource.type=\"global\""
      duration        = "60s"
      comparison      = "COMPARISON_LESS_THAN"
      threshold_value = var.target_quality_score
      
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email_alerts.name]
  
  severity = "WARNING"
}

# Alert Policy for Cost Exceeded
resource "google_monitoring_alert_policy" "cost_exceeded_alert" {
  display_name = "${var.environment} - Cost per Video Exceeded"
  project      = var.project_id
  
  conditions {
    display_name = "Cost per video exceeds $${var.target_cost_per_video}"
    
    condition_threshold {
      filter          = "resource.type=\"global\""
      duration        = "300s"
      comparison      = "COMPARISON_GREATER_THAN"
      threshold_value = var.target_cost_per_video
      
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.email_alerts.name]
  
  severity = "WARNING"
}

# Alert Policy for Worker Function Errors
resource "google_monitoring_alert_policy" "worker_error_alert" {
  display_name = "${var.environment} - Worker Function Errors"
  project      = var.project_id
  
  conditions {
    display_name = "High error rate in worker functions"
    
    condition_threshold {
      filter          = "resource.type=\"cloud_function\" AND resource.labels.function_name=~\"${var.environment}-.*\""
      duration        = "300s"
      comparison      = "COMPARISON_GREATER_THAN"
      threshold_value = 0.05  # 5% error rate
      
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = ["resource.labels.function_name"]
      }
    }
  }
  
  notification_channels = [
    google_monitoring_notification_channel.email_alerts.name,
    google_monitoring_notification_channel.slack_alerts.name
  ]
  
  severity = "CRITICAL"
}

# Notification Channels
resource "google_monitoring_notification_channel" "email_alerts" {
  display_name = "${var.environment} Email Alerts"
  type         = "email"
  project      = var.project_id
  
  labels = {
    email_address = "alerts@estudio-vertice.com"  # Replace with actual email
  }
}

resource "google_monitoring_notification_channel" "slack_alerts" {
  display_name = "${var.environment} Slack Alerts"
  type         = "slack"
  project      = var.project_id
  
  labels = {
    channel_name = "#estudio-vertice-alerts"
    url          = "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"  # Replace with actual webhook
  }
  
  sensitive_labels {
    auth_token = "xoxb-your-slack-bot-token"  # Replace with actual token
  }
}

# Custom Metrics for Kurzgesagt-specific measurements
resource "google_logging_metric" "kurzgesagt_compliance_score" {
  name   = "${var.environment}_kurzgesagt_compliance_score"
  filter = "resource.type=\"cloud_function\" AND jsonPayload.kurzgesagt_compliance_score > 0"
  project = var.project_id
  
  metric_descriptor {
    metric_kind = "GAUGE"
    value_type  = "DOUBLE"
    display_name = "Kurzgesagt Compliance Score"
  }
  
  value_extractor = "EXTRACT(jsonPayload.kurzgesagt_compliance_score)"
}

resource "google_logging_metric" "nihilistic_optimism_balance" {
  name   = "${var.environment}_nihilistic_optimism_balance"
  filter = "resource.type=\"cloud_function\" AND jsonPayload.nihilistic_optimism_score > 0"
  project = var.project_id
  
  metric_descriptor {
    metric_kind = "GAUGE"
    value_type  = "DOUBLE"
    display_name = "Nihilistic Optimism Balance Score"
  }
  
  value_extractor = "EXTRACT(jsonPayload.nihilistic_optimism_score)"
}

resource "google_logging_metric" "success_prediction_accuracy" {
  name   = "${var.environment}_success_prediction_accuracy"
  filter = "resource.type=\"cloud_function\" AND jsonPayload.prediction_accuracy > 0"
  project = var.project_id
  
  metric_descriptor {
    metric_kind = "GAUGE"
    value_type  = "DOUBLE"
    display_name = "Success Prediction Accuracy"
  }
  
  value_extractor = "EXTRACT(jsonPayload.prediction_accuracy)"
}

# SLO (Service Level Objectives) for key metrics
resource "google_monitoring_slo" "processing_time_slo" {
  service      = google_monitoring_service.estudio_vertice_service.service_id
  slo_id       = "processing-time-slo"
  display_name = "Processing Time SLO"
  project      = var.project_id
  
  goal                = 0.95  # 95% of requests should meet target
  rolling_period_days = 30
  
  request_based_sli {
    good_total_ratio {
      total_service_filter = "resource.type=\"cloud_function\""
      good_service_filter  = "resource.type=\"cloud_function\" AND metric.labels.response_code=\"200\""
    }
  }
}

resource "google_monitoring_slo" "quality_score_slo" {
  service      = google_monitoring_service.estudio_vertice_service.service_id
  slo_id       = "quality-score-slo"
  display_name = "Quality Score SLO"
  project      = var.project_id
  
  goal                = 0.90  # 90% of videos should meet quality target
  rolling_period_days = 30
  
  request_based_sli {
    good_total_ratio {
      total_service_filter = "resource.type=\"global\""
      good_service_filter  = "resource.type=\"global\" AND metric.labels.quality_score>=${var.target_quality_score}"
    }
  }
}

# Service definition for SLOs
resource "google_monitoring_service" "estudio_vertice_service" {
  service_id   = "${var.environment}-estudio-vertice"
  display_name = "Estúdio Vértice ${title(var.environment)}"
  project      = var.project_id
}

# Log-based alert for specific error patterns
resource "google_logging_metric" "critical_errors" {
  name   = "${var.environment}_critical_errors"
  filter = "resource.type=\"cloud_function\" AND severity>=ERROR AND (jsonPayload.error_type=\"kurzgesagt_compliance_failure\" OR jsonPayload.error_type=\"quality_below_threshold\")"
  project = var.project_id
  
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    display_name = "Critical Errors Count"
  }
}

resource "google_monitoring_alert_policy" "critical_errors_alert" {
  display_name = "${var.environment} - Critical Errors"
  project      = var.project_id
  
  conditions {
    display_name = "Critical errors detected"
    
    condition_threshold {
      filter          = "resource.type=\"logging_metric\" AND metric.type=\"logging.googleapis.com/user/${var.environment}_critical_errors\""
      duration        = "60s"
      comparison      = "COMPARISON_GREATER_THAN"
      threshold_value = 0
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [
    google_monitoring_notification_channel.email_alerts.name,
    google_monitoring_notification_channel.slack_alerts.name
  ]
  
  severity = "CRITICAL"
}

# Uptime check for main workflow endpoint
resource "google_monitoring_uptime_check_config" "workflow_uptime" {
  display_name = "${var.environment} Workflow Health Check"
  timeout      = "10s"
  period       = "300s"
  project      = var.project_id
  
  http_check {
    path         = "/health"
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }
  
  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = "${var.region}-${var.project_id}.cloudfunctions.net"
    }
  }
  
  content_matchers {
    content = "healthy"
    matcher = "CONTAINS_STRING"
  }
}

# Error reporting configuration
resource "google_project_service" "error_reporting" {
  service = "clouderrorreporting.googleapis.com"
  project = var.project_id
}

# Cloud Trace for performance monitoring
resource "google_project_service" "cloud_trace" {
  service = "cloudtrace.googleapis.com"
  project = var.project_id
}

# Cloud Profiler for application performance
resource "google_project_service" "cloud_profiler" {
  service = "cloudprofiler.googleapis.com"
  project = var.project_id
}