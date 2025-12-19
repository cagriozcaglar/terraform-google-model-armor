# This module is used to create and manage a Google Cloud Model Armor template.
# Model Armor helps protect Large Language Models (LLMs) from harmful inputs and abuse
# by providing configurable detection and filtering capabilities.
#
# This module follows best practices for authoring Terraform modules, including
# auto-generated documentation via terraform-docs and integration tests
# using blueprint-test.
resource "google_model_armor_template" "model_armor" {
  # The ID of the Google Cloud project in which to create the resource.
  project = var.project_id

  # The location for the Model Armor Template. This is a global resource and the value should be 'global'.
  location = var.location

  # The user-provided ID of the Model Armor template. It must be unique within the location.
  template_id = var.name

  # The policy configuration for the Model Armor template.
  filter_config {
    # A list of filters to apply. A template must have exactly one policy filter.
    filters {
      # The policy defines the detection and filtering rules.
      policy {
        # The user-friendly display name for the policy.
        display_name = var.filter_config.display_name

        # (Optional) A textual description of the policy.
        description = var.filter_config.description

        # Defines a list of detection rules to apply. Each rule specifies a signature, action, sensitivity, and optional topic filter.
        dynamic "detection_rule" {
          for_each = var.filter_config.detection_rules
          content {
            # The ID of the signature to be used for this rule (e.g., 'PROMPT_INJECTION').
            signature_id = detection_rule.value.signature_id

            # The action to take when the signature is matched (e.g., 'BLOCK').
            action = detection_rule.value.action

            # The sensitivity of the signature (e.g., 'MEDIUM').
            sensitivity = detection_rule.value.sensitivity

            # This block configures topic-based filtering. It is included only if a topic_filter is provided for the rule.
            dynamic "topic_filter" {
              for_each = detection_rule.value.topic_filter != null ? [detection_rule.value.topic_filter] : []
              content {
                # (Optional) A list of topics that are explicitly allowed. If specified, any topic not in this list will be blocked.
                allowed_topics = topic_filter.value.allowed_topics

                # (Optional) A list of topics that are explicitly blocked.
                blocked_topics = topic_filter.value.blocked_topics
              }
            }
          }
        }
      }
    }
  }
}
