resource "google_bigquery_dataset" "cat_facts" {
  project                     = var.DEPLOY_PROJECT
  dataset_id                  = "cat_facts"
  friendly_name               = "Dataset for cat facts"
  description                 = "This is the dataset for cat facts"
  location                    = var.BQ_REGION
  default_table_expiration_ms = 3155760000000
  max_time_travel_hours       = 168

  labels = {
    # jurisdiction = var.BQ_REGION
    datatype     = "autofilled"
    catalog_id   = "autofilled"
  }
}

resource "google_bigquery_table" "cat_facts" {
  project     = var.DEPLOY_PROJECT
  table_id    = "cat_facts"
  deletion_protection = false

  dataset_id  = google_bigquery_dataset.cat_facts.dataset_id

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = file("../schemas/bq_schema.json")
}
