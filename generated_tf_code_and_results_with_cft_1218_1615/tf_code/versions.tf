# Specifies the Terraform and provider versions.
terraform {
  # Specifies the minimum required version of Terraform.
  required_version = ">= 1.0"
  # Defines the required providers for this module.
  required_providers {
    # Specifies the Google Beta provider is required.
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.23.0"
    }
  }
}
