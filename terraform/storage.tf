resource "google_storage_bucket" "etl_job_bucket" {
  name                        = "etl_job_bucket"
  project                     = var.DEPLOY_PROJECT
  location                    = var.REGION
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "json_schema" {
  name   = "schema_folder/json_schema.json"
  source = "../schemas/json_schema.json"
  bucket = google_storage_bucket.etl_job_bucket.name
}

resource "google_storage_bucket_object" "bq_schema" {
  name = "schema_folder/bq_schema.json"
  source = "../schemas/json_schema.json"
  bucket = google_storage_bucket.etl_job_bucket.name
}

resource "google_storage_bucket" "etl_job_cf_bucket" {
  name                        = "etl_job_cf_bucket"
  project                     = var.DEPLOY_PROJECT
  location                    = var.REGION
  uniform_bucket_level_access = true
  force_destroy               = true
}
