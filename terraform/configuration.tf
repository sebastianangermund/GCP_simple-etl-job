terraform {
  backend "gcs" {
  }
  required_providers {
    google = {}
  }
}

provider "google" {
  alias = "google"
  project = var.DEPLOY_PROJECT
  region  = var.REGION
  zone    = var.ZONE
}
