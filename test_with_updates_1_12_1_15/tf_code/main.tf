# This file contains the main resource definition for the Terraform module.
# It creates a Google Model Armor Template based on the provided variables.
resource "google_model_armor_template" "main" {
  # The project ID where the Model Armor Template will be created. If not provided, the provider project will be used.
  project = var.project_id
  # The location for the Model Armor Template.
  location = var.location
  # The user-provided ID for the Model Armor Template.
  template_id = var.template_id
  # Labels to apply to the Model Armor Template.
  labels = var.labels

  # This dynamic block configures the filters for the template. It is a required block.
  dynamic "filter_config" {
    # Iterates once over the provided filter_config object.
    for_each = [var.filter_config]
    content {

      # This dynamic block configures the Malicious URI filter settings.
      dynamic "malicious_uri_filter_settings" {
        # Creates the block only if malicious_uri_filter_settings is provided in the input variable.
        for_each = filter_config.value.malicious_uri_filter_settings != null ? [filter_config.value.malicious_uri_filter_settings] : []
        content {
          # Determines if the Malicious URI filter is enabled or disabled. Possible values are "ENABLED" or "DISABLED".
          filter_enforcement = malicious_uri_filter_settings.value.filter_enforcement
        }
      }

      # This dynamic block configures the Prompt Injection and Jailbreak Filter settings.
      dynamic "pi_and_jailbreak_filter_settings" {
        # Creates the block only if pi_and_jailbreak_filter_settings is provided.
        for_each = filter_config.value.pi_and_jailbreak_filter_settings != null ? [filter_config.value.pi_and_jailbreak_filter_settings] : []
        content {
          # The confidence level for the filter. Possible values are "LOW_AND_ABOVE", "MEDIUM_AND_ABOVE", "HIGH".
          confidence_level = pi_and_jailbreak_filter_settings.value.confidence_level
          # Determines if the filter is enabled or disabled. Possible values are "ENABLED" or "DISABLED".
          filter_enforcement = pi_and_jailbreak_filter_settings.value.filter_enforcement
        }
      }

      # This dynamic block configures the Responsible AI Filter settings.
      dynamic "rai_settings" {
        # Creates the block only if rai_settings is provided.
        for_each = filter_config.value.rai_settings != null ? [filter_config.value.rai_settings] : []
        content {

          # This dynamic block configures the list of Responsible AI filters.
          dynamic "rai_filters" {
            # Iterates over the list of rai_filters provided in the input variable.
            for_each = rai_settings.value.rai_filters
            content {
              # The type of RAI filter. Possible values are "SEXUALLY_EXPLICIT", "HATE_SPEECH", "HARASSMENT", "DANGEROUS".
              filter_type = rai_filters.value.filter_type
              # The confidence level for the filter. Possible values are "LOW_AND_ABOVE", "MEDIUM_AND_ABOVE", "HIGH".
              confidence_level = rai_filters.value.confidence_level
            }
          }
        }
      }

      # This dynamic block configures the Sensitive Data Protection settings.
      dynamic "sdp_settings" {
        # Creates the block only if sdp_settings is provided.
        for_each = filter_config.value.sdp_settings != null ? [filter_config.value.sdp_settings] : []
        content {

          # This dynamic block configures the basic Sensitive Data Protection settings.
          dynamic "basic_config" {
            # Creates the block only if basic_config is provided.
            for_each = sdp_settings.value.basic_config != null ? [sdp_settings.value.basic_config] : []
            content {
              # Determines if the basic SDP filter is enabled or disabled. Possible values are "ENABLED" or "DISABLED".
              filter_enforcement = basic_config.value.filter_enforcement
            }
          }

          # This dynamic block configures the advanced Sensitive Data Protection settings.
          dynamic "advanced_config" {
            # Creates the block only if advanced_config is provided.
            for_each = sdp_settings.value.advanced_config != null ? [sdp_settings.value.advanced_config] : []
            content {
              # The resource name of the SDP inspect template.
              inspect_template = advanced_config.value.inspect_template
              # The resource name of the SDP de-identify template.
              deidentify_template = advanced_config.value.deidentify_template
            }
          }
        }
      }
    }
  }

  # This dynamic block configures the metadata for the template. It is an optional block.
  dynamic "template_metadata" {
    # Creates the block only if template_metadata is provided in the input variable.
    for_each = var.template_metadata != null ? [var.template_metadata] : []
    content {
      # The enforcement type for the template. Possible values are "INSPECT_ONLY", "INSPECT_AND_BLOCK".
      enforcement_type = template_metadata.value.enforcement_type
      # If true, logs sanitize operations.
      log_sanitize_operations = template_metadata.value.log_sanitize_operations
      # If true, logs template CRUD operations.
      log_template_operations = template_metadata.value.log_template_operations
      # If true, partial detector failures will be ignored.
      ignore_partial_invocation_failures = template_metadata.value.ignore_partial_invocation_failures
      # Custom error code to return if a prompt trips Model Armor filters.
      custom_prompt_safety_error_code = template_metadata.value.custom_prompt_safety_error_code
      # Custom error message to return if a prompt trips Model Armor filters.
      custom_prompt_safety_error_message = template_metadata.value.custom_prompt_safety_error_message
      # Custom error code to return if an LLM response trips Model Armor filters.
      custom_llm_response_safety_error_code = template_metadata.value.custom_llm_response_safety_error_code
      # Custom error message to return if an LLM response trips Model Armor filters.
      custom_llm_response_safety_error_message = template_metadata.value.custom_llm_response_safety_error_message

      # This dynamic block configures multi-language detection settings.
      dynamic "multi_language_detection" {
        # Creates the block only if multi_language_detection is provided.
        for_each = template_metadata.value.multi_language_detection != null ? [template_metadata.value.multi_language_detection] : []
        content {
          # If true, multi-language detection will be enabled.
          enable_multi_language_detection = multi_language_detection.value.enable_multi_language_detection
        }
      }
    }
  }
}
