terraform {
  backend "gcs" {
    bucket = "331634d07e1bec1e-bucket-tfstate"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

provider "random" {}

provider "google" {
  region = "us-central1"
}

resource "google_project" "main" {
  name            = "main"
  project_id      = "seanjh-main"
  billing_account = "01E914-E0F59B-0179EF"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "terraform_state" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  project       = google_project.main.project_id

  versioning {
    enabled = true
  }
}
