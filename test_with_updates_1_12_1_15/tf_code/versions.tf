# The terraform block is used to configure aspects of Terraform itself.
# It includes settings for required providers and their versions.
terraform {
  # Specifies the required Terraform version.
  required_version = ">= 1.3"
  required_providers {
    # Specifies the required Google Cloud Platform provider and its version.
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}
