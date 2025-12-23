# The terraform block is used to configure aspects of Terraform itself.
# It includes settings for required providers, which Terraform uses to interact with cloud providers and other APIs.
terraform {
  # The required_providers block specifies the providers required by the current module.
  # Each provider is identified by a source address and a version constraint.
  required_providers {
    # This entry specifies that the 'google' provider is required.
    google = {
      # The 'source' attribute defines where to download the provider from (HashCorp's public registry).
      source = "hashicorp/google"
      # The 'version' attribute specifies a version constraint, ensuring that a compatible version of the provider is used.
      # The 'google_model_armor_template' resource was introduced in version 5.41.0.
      version = "~> 5.41"
    }
  }
}
