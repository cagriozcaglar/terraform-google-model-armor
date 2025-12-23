# This module creates a Google Cloud Model Armor template to protect Vertex AI model endpoints
# from adversarial attacks. It allows for flexible configuration of policy rules, logging,
# and notifications.
#
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

resource "google_model_armor_template" "model_armor" {
  # The user-provided ID for the Model Armor template.
  template_id = var.template_id
  # The user-provided display name for the Model Armor template.
  display_name = var.display_name
  # The GCP region for the Model Armor template.
  location = var.location
  # The project ID to host the Model Armor template. If not provided, the provider project is used.
  project = var.project_id
  # An optional description for the Model Armor template.
  description = var.description
  # User-defined labels for the Model Armor template.
  labels = var.labels

  # The configuration for the template.
  filter_config {
    # The default action to take when no rules match a request.
    default_action = var.default_rule_action

    # A block containing the set of policy rules.
    rule_set {
      # A dynamic block to create policy rules based on the input variable.
      dynamic "rules" {
        for_each = var.policy_rules
        content {
          # The action to take when the rule is matched.
          action = rules.value.action
          # An optional description for the rule.
          description = rules.value.description

          # The match condition for the rule.
          match {
            # A list of attack signatures to match against.
            attack_signatures = rules.value.attack_signatures
          }

          # The configuration for the rule's action. This block is created only if the action is 'BLOCK_AND_QUARANTINE'.
          # This ensures quarantine_destination is only provided for the correct action.
          dynamic "config" {
            for_each = rules.value.action == "BLOCK_AND_QUARANTINE" ? [1] : []
            content {
              # The sensitivity level for attack detection.
              sensitivity_level = rules.value.sensitivity_level
              # The GCS bucket URL to quarantine suspicious input data.
              quarantine_destination = rules.value.quarantine_destination
            }
          }

          # The configuration for the rule's action. This block is created for actions other than 'BLOCK_AND_QUARANTINE'.
          dynamic "config" {
            for_each = rules.value.action != "BLOCK_AND_QUARANTINE" ? [1] : []
            content {
              # The sensitivity level for attack detection.
              sensitivity_level = rules.value.sensitivity_level
            }
          }
        }
      }
    }

    # Conditional block for logging configuration.
    dynamic "logging_config" {
      for_each = var.enable_logging ? [1] : []
      content {
        # Enables logging of detected threats.
        enable_logging = var.enable_logging
        # The BigQuery dataset to write threat logs to.
        # Format: `projects/{project}/datasets/{dataset}`
        log_destination_bigquery = var.log_destination_bigquery
      }
    }

    # Conditional block for notification configuration.
    dynamic "notification_config" {
      for_each = var.notification_pubsub_topic != null ? [1] : []
      content {
        # The Pub/Sub topic to send security event notifications to.
        # Format: `projects/{project}/topics/{topic}`
        pubsub_topic = var.notification_pubsub_topic
      }
    }
  }

  # Precondition to ensure that if logging is enabled, a destination is provided.
  lifecycle {
    precondition {
      condition     = !var.enable_logging || var.log_destination_bigquery != null
      error_message = "If 'enable_logging' is true, 'log_destination_bigquery' must be provided."
    }
  }
}
