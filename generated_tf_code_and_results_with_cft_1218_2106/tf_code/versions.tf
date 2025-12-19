# Specifies the required Terraform version.
terraform {
  required_version = ">= 1.3"

  required_providers {
    # Specifies the required Google Cloud provider and its version constraints.
    google = {
      # The official HashiCorp Google Cloud provider.
      source  = "hashicorp/google"
      # The recommended version of the provider.
      version = ">= 5.37.0"
    }
  }
}
