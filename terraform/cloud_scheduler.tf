resource "google_cloud_scheduler_job" "trigger_simple_etl_job" {
  project           = var.DEPLOY_PROJECT
  region            = var.CF_REGION
  name              = "trigger-simple-etl-job"
  description       = "trigger-simple-etl-job"
  schedule          = "*/5 * * * *"
  time_zone         = "Europe/Stockholm"
  attempt_deadline  = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.etl_job.https_trigger_url
    body        = base64encode("{}")
    headers = {
      "Content-Type" = "application/json"
    }
    oidc_token {
      service_account_email = ""
    }
  }
}
