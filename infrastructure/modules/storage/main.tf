# Main storage bucket for project assets
resource "google_storage_bucket" "main" {
  name          = "${var.project_name}-${var.environment}-main"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

# Input content bucket
resource "google_storage_bucket" "input" {
  name          = "${var.project_name}-${var.environment}-input"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}

# Processed content bucket
resource "google_storage_bucket" "processed" {
  name          = "${var.project_name}-${var.environment}-processed"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}

# Final videos bucket
resource "google_storage_bucket" "videos" {
  name          = "${var.project_name}-${var.environment}-videos"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}

# Models and training data bucket
resource "google_storage_bucket" "models" {
  name          = "${var.project_name}-${var.environment}-models"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}

# Analytics and metrics bucket
resource "google_storage_bucket" "analytics" {
  name          = "${var.project_name}-${var.environment}-analytics"
  location      = var.region
  project       = var.project_id
  force_destroy = true

  uniform_bucket_level_access = true
}

# Terraform state bucket (if needed)
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_name}-${var.environment}-terraform-state"
  location      = var.region
  project       = var.project_id
  force_destroy = false

  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
}