terraform {
  # This module requires Terraform version 1.3 or newer.
  required_version = ">= 1.3"

  # This module requires the Google Provider.
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.3"
    }
  }
}
