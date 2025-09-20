# Cloud Function for Content Analyzer
resource "google_cloudfunctions2_function" "content_analyzer" {
  name     = "${var.environment}-content-analyzer"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/content-analyzer.zip"
      }
    }
  }

  service_config {
    max_instance_count = 100
    min_instance_count = 0
    available_memory   = "512Mi"
    timeout_seconds    = 540
    
    environment_variables = {
      ENVIRONMENT    = var.environment
      STORAGE_BUCKET = var.storage_bucket
      PROJECT_ID     = var.project_id
    }
  }
}

# Cloud Function for Script Generator
resource "google_cloudfunctions2_function" "script_generator" {
  name     = "${var.environment}-script-generator"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/script-generator.zip"
      }
    }
  }

  service_config {
    max_instance_count = 100
    min_instance_count = 0
    available_memory   = "1Gi"
    timeout_seconds    = 540
    
    environment_variables = {
      ENVIRONMENT           = var.environment
      STORAGE_BUCKET       = var.storage_bucket
      PROJECT_ID           = var.project_id
      KURZGESAGT_TEMPLATES = "true"
      NIHILISTIC_OPTIMISM  = "true"
    }
  }
}

# Cloud Function for Visual Designer
resource "google_cloudfunctions2_function" "visual_designer" {
  name     = "${var.environment}-visual-designer"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/visual-designer.zip"
      }
    }
  }

  service_config {
    max_instance_count = 50
    min_instance_count = 0
    available_memory   = "2Gi"
    timeout_seconds    = 540
    
    environment_variables = {
      ENVIRONMENT    = var.environment
      STORAGE_BUCKET = var.storage_bucket
      PROJECT_ID     = var.project_id
      IMAGEN_API     = "true"
    }
  }
}

# Cloud Function for Audio Synthesizer
resource "google_cloudfunctions2_function" "audio_synthesizer" {
  name     = "${var.environment}-audio-synthesizer"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/audio-synthesizer.zip"
      }
    }
  }

  service_config {
    max_instance_count = 50
    min_instance_count = 0
    available_memory   = "1Gi"
    timeout_seconds    = 540
    
    environment_variables = {
      ENVIRONMENT    = var.environment
      STORAGE_BUCKET = var.storage_bucket
      PROJECT_ID     = var.project_id
      TTS_API        = "true"
    }
  }
}

# Cloud Function for Quality Assurer
resource "google_cloudfunctions2_function" "quality_assurer" {
  name     = "${var.environment}-quality-assurer"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/quality-assurer.zip"
      }
    }
  }

  service_config {
    max_instance_count = 50
    min_instance_count = 0
    available_memory   = "1Gi"
    timeout_seconds    = 540
    
    environment_variables = {
      ENVIRONMENT       = var.environment
      STORAGE_BUCKET    = var.storage_bucket
      PROJECT_ID        = var.project_id
      TARGET_QUALITY    = "9.0"
      ENABLE_AI_REVIEW  = "true"
    }
  }
}

# Cloud Function for Performance Analyzer
resource "google_cloudfunctions2_function" "performance_analyzer" {
  name     = "${var.environment}-performance-analyzer"
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.storage_bucket
        object = "functions/performance-analyzer.zip"
      }
    }
  }

  service_config {
    max_instance_count = 100
    min_instance_count = 1
    available_memory   = "512Mi"
    timeout_seconds    = 540
    
    environment_variables = {
      ENVIRONMENT          = var.environment
      STORAGE_BUCKET       = var.storage_bucket
      PROJECT_ID           = var.project_id
      ENABLE_ANALYTICS     = "true"
      ENABLE_PREDICTIONS   = "true"
    }
  }
}

# IAM bindings for the functions
resource "google_cloudfunctions2_function_iam_binding" "content_analyzer_invoker" {
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.content_analyzer.name
  role           = "roles/cloudfunctions.invoker"
  members        = ["allUsers"]
}

resource "google_cloudfunctions2_function_iam_binding" "script_generator_invoker" {
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.script_generator.name
  role           = "roles/cloudfunctions.invoker"
  members        = ["allUsers"]
}

resource "google_cloudfunctions2_function_iam_binding" "visual_designer_invoker" {
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.visual_designer.name
  role           = "roles/cloudfunctions.invoker"
  members        = ["allUsers"]
}

resource "google_cloudfunctions2_function_iam_binding" "audio_synthesizer_invoker" {
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.audio_synthesizer.name
  role           = "roles/cloudfunctions.invoker"
  members        = ["allUsers"]
}

resource "google_cloudfunctions2_function_iam_binding" "quality_assurer_invoker" {
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.quality_assurer.name
  role           = "roles/cloudfunctions.invoker"
  members        = ["allUsers"]
}

resource "google_cloudfunctions2_function_iam_binding" "performance_analyzer_invoker" {
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.performance_analyzer.name
  role           = "roles/cloudfunctions.invoker"
  members        = ["allUsers"]
}