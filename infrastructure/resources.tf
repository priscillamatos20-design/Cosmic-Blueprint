# Enable required Google Cloud APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "cloudrun.googleapis.com", 
    "workflows.googleapis.com",
    "aiplatform.googleapis.com",
    "storage.googleapis.com",
    "cloudbuild.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com",
    "eventarc.googleapis.com",
    "pubsub.googleapis.com"
  ])

  project = var.project_id
  service = each.key

  disable_dependent_services = false
  disable_on_destroy        = false
}

# Storage module
module "storage" {
  source = "./modules/storage"
  
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  project_name = var.project_name
  
  depends_on = [google_project_service.apis]
}

# Workers module (6 Cloud Functions)
module "workers" {
  source = "./modules/workers"
  
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  
  storage_bucket = module.storage.main_bucket_name
  
  depends_on = [google_project_service.apis, module.storage]
}

# Orchestration module (Workflows)
module "orchestration" {
  source = "./modules/orchestration"
  
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  
  worker_functions = module.workers.function_names
  storage_bucket = module.storage.main_bucket_name
  
  depends_on = [module.workers]
}

# Intelligence module (Vertex AI & ML)
module "intelligence" {
  source = "./modules/intelligence"
  
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  
  storage_bucket = module.storage.main_bucket_name
  
  depends_on = [google_project_service.apis, module.storage]
}

# Monitoring module
module "monitoring" {
  source = "./modules/monitoring"
  
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  
  worker_functions = module.workers.function_names
  workflow_id = module.orchestration.workflow_id
  
  target_processing_time_minutes = var.target_processing_time_minutes
  target_quality_score = var.target_quality_score
  target_cost_per_video = var.target_cost_per_video
  
  depends_on = [module.workers, module.orchestration]
}