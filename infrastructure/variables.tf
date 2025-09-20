variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "estudio-vertice-ai"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "estudio-vertice"
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
  description = "Target cost per video in USD"
  type        = number
  default     = 2.50
}

variable "enable_monitoring" {
  description = "Enable monitoring and alerting"
  type        = bool
  default     = true
}

variable "enable_vertex_ai" {
  description = "Enable Vertex AI services"
  type        = bool
  default     = true
}

variable "enable_workflows" {
  description = "Enable Google Cloud Workflows"
  type        = bool
  default     = true
}