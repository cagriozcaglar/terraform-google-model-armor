terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.3.0"
    }
  }
}
