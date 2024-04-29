data "archive_file" "etl_job" {
  type        = "zip"
  source_dir  = "../cloud_functions/extract_transform_load/src"
  output_path = "../cloud_functions/ETL.zip"
}

resource "null_resource" "etl_job" {
  triggers = {
    hash = data.archive_file.etl_job.output_sha
  }
}

resource "google_storage_bucket_object" "etl_job" {
  name         = "src-${data.archive_file.etl_job.output_md5}.zip"
  bucket       = google_storage_bucket.etl_job_cf_bucket.name
  source       = data.archive_file.etl_job.output_path
  content_type = "application/zip"
}

resource "google_cloudfunctions_function" "etl_job" {
  name                         = "simple_etl_job"
  description                  = "Simple ETL job"
  region                       = var.CF_REGION
  project                      = var.DEPLOY_PROJECT
  runtime                      = "python39"
  available_memory_mb          = 256
  entry_point                  = "main"
  service_account_email        = ""
  trigger_http                 = true
  # https_trigger_security_level = "SECURE_ALWAYS"
  source_archive_bucket        = google_storage_bucket.etl_job_cf_bucket.name
  source_archive_object        = google_storage_bucket_object.etl_job.name
  timeout                      = 300
  environment_variables = {
    JSON_SCHEMA_PATH    = google_storage_bucket_object.json_schema.name
    JSON_SCHEMA_BUCKET  = google_storage_bucket.etl_job_bucket.name
    DATASET_NAME        = google_bigquery_dataset.cat_facts.dataset_id
    TABLE_NAME          = google_bigquery_table.cat_facts.table_id
    API_ENDPOINT        = "https://cat-fact.herokuapp.com/facts"
  }
}
