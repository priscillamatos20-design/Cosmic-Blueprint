variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "worker_functions" {
  description = "Map of worker function names"
  type        = map(string)
}

variable "workflow_id" {
  description = "Workflow ID for monitoring"
  type        = string
}

variable "target_processing_time_minutes" {
  description = "Target processing time in minutes"
  type        = number
  default     = 8
}

variable "target_quality_score" {
  description = "Target quality score"
  type        = number
  default     = 9.0
}

variable "target_cost_per_video" {
  description = "Target cost per video"
  type        = number
  default     = 2.50
}