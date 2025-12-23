# This is the main resource block for creating a Google Cloud Model Armor Template.
# Model Armor templates define a reusable set of security policies that can be applied to Vertex AI endpoints
# to protect models from misuse and adversarial attacks.
resource "google_model_armor_template" "main" {
  # The GCP project ID where the Model Armor template will be created.
  project = var.project_id
  # The GCP location where the Model Armor template will be created.
  location = var.location
  # The user-defined name of the ModelArmorTemplate. This will be the last part of the resource name.
  name = var.template_id

  # The filter_config block defines the security policies for the template. At least one must be configured.
  filter_config {
    # The user-friendly name for the Model Armor template.
    display_name = var.display_name
    # A detailed description of the Model Armor template's purpose.
    description = var.description

    # This dynamic block configures threat detection policies.
    # It is created only if the 'threat_detection_policy' variable is provided.
    dynamic "threat_detection_config" {
      for_each = var.threat_detection_policy != null ? [var.threat_detection_policy] : []
      content {

        # This dynamic block configures adversarial attack detection settings.
        dynamic "adversarial_attack_detection_config" {
          for_each = threat_detection_config.value.adversarial_attack_detection != null ? [threat_detection_config.value.adversarial_attack_detection] : []
          content {
            # Enables or disables the adversarial attack detection feature.
            enabled = adversarial_attack_detection_config.value.enabled
            # The sensitivity level for adversarial attack detection.
            sensitivity_level = lookup(adversarial_attack_detection_config.value, "sensitivity_level", null)
          }
        }

        # This dynamic block configures prompt injection detection settings.
        dynamic "prompt_injection_detection_config" {
          for_each = threat_detection_config.value.prompt_injection_detection != null ? [threat_detection_config.value.prompt_injection_detection] : []
          content {
            # Enables or disables the prompt injection detection feature.
            enabled = prompt_injection_detection_config.value.enabled
          }
        }
      }
    }

    # This dynamic block configures input validation policies.
    # It is created only if the 'input_validation_safety_attributes' variable is provided.
    dynamic "input_validation_config" {
      for_each = var.input_validation_safety_attributes != null ? [var.input_validation_safety_attributes] : []
      content {
        # The safety_filter_config block defines safety filters for input validation.
        safety_filter_config {
          # The blocking score for toxicity.
          toxicity = lookup(input_validation_config.value, "toxicity", null)
          # The blocking score for sexually explicit content.
          sexually_explicit = lookup(input_validation_config.value, "sexually_explicit", null)
          # The blocking score for hate speech.
          hate_speech = lookup(input_validation_config.value, "hate_speech", null)
          # The blocking score for dangerous content.
          dangerous_content = lookup(input_validation_config.value, "dangerous_content", null)
        }
      }
    }

    # This dynamic block configures output scrubbing policies.
    # It is created only if the 'output_scrubbing_pii_detection' variable is provided.
    dynamic "output_scrubbing_config" {
      for_each = var.output_scrubbing_pii_detection != null ? [var.output_scrubbing_pii_detection] : []
      content {
        # The pii_detection_config block configures PII detection for output scrubbing.
        pii_detection_config {
          # A list of PII info types to detect.
          info_types = lookup(output_scrubbing_config.value, "info_types", null)
          # The strategy to use for redacting detected PII.
          redaction_strategy = lookup(output_scrubbing_config.value, "redaction_strategy", null)
        }
      }
    }

    # This dynamic block configures logging for detected incidents.
    # It is created only if the 'logging_config' variable is provided.
    dynamic "logging_config" {
      for_each = var.logging_config != null ? [var.logging_config] : []
      content {
        # Enables or disables logging for this template.
        enabled = logging_config.value.enabled

        # This dynamic block sets the destination for logs.
        dynamic "log_destination" {
          for_each = lookup(logging_config.value, "log_destination", null) != null ? [logging_config.value.log_destination] : []
          content {
            # The full resource name of the Pub/Sub topic to send logs to.
            pubsub_topic = log_destination.value.pubsub_topic
          }
        }
      }
    }
  }

  # This lifecycle block enforces that at least one security policy is defined, as required by the provider.
  lifecycle {
    precondition {
      condition     = var.threat_detection_policy != null || var.input_validation_safety_attributes != null || var.output_scrubbing_pii_detection != null
      error_message = "At least one security policy (threat_detection_policy, input_validation_safety_attributes, or output_scrubbing_pii_detection) must be configured for the Model Armor template."
    }
  }
}
