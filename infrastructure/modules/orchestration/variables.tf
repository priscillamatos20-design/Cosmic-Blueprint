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

variable "storage_bucket" {
  description = "Main storage bucket name"
  type        = string
}