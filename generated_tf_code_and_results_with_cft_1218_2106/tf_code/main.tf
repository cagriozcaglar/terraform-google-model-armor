# This resource defines a Model Armor template to protect Vertex AI Endpoints.
# Model Armor helps protect models from misuse and attacks by providing a configurable security policy layer.
# This template can be applied to endpoints in a separate configuration.
resource "google_model_armor_template" "this" {
  # The GCP project ID where the template is created.
  project = var.project_id
  # The GCP region where the template is located.
  location = var.location
  # The user-provided ID for the template.
  template_id = var.template_id

  # The policy block contains the Model Armor filtering rules and configurations.
  policy {
    # The display name for the template. Defaults to the template_id if not provided.
    display_name = coalesce(var.display_name, var.template_id)
    # An optional description for the template.
    description = var.description

    # This block is only created if signature rules are provided.
    # It defines rules based on predefined attack signatures.
    dynamic "signature" {
      # Check if the list of rules is not empty.
      for_each = length(var.signature_config_rules) > 0 ? [1] : []
      content {
        # Dynamic block to create multiple rule blocks.
        dynamic "rules" {
          # Iterate over each rule object in the input variable.
          for_each = var.signature_config_rules
          content {
            # The action to perform when the rule matches, e.g., 'BLOCK'.
            action = rules.value.action
            # The priority of the rule, with lower numbers evaluated first.
            priority = rules.value.priority
            # The ID of a pre-configured signature for attack detection.
            signature_id = rules.value.signature_id
            # An optional description for the rule.
            description = rules.value.description
          }
        }
      }
    }

    # This block is only created if anomaly thresholds are provided.
    # It defines the configuration for detecting anomalies in input data.
    dynamic "baseline_model" {
      # Check if the list of thresholds is not empty.
      for_each = length(var.baseline_model_config_anomaly_thresholds) > 0 ? [1] : []
      content {
        # Dynamic block to create multiple anomaly_thresholds blocks.
        dynamic "anomaly_thresholds" {
          # Iterate over each threshold object in the input variable.
          for_each = var.baseline_model_config_anomaly_thresholds
          content {
            # The type of anomaly to detect, e.g., 'high_similarity'.
            anomaly_type = anomaly_thresholds.value.anomaly_type
            # The threshold value for triggering the anomaly detection.
            threshold = anomaly_thresholds.value.threshold
          }
        }
      }
    }
  }

  # Precondition to ensure that the template is not created with an empty policy.
  # At least one of signature or baseline_model must be specified.
  lifecycle {
    precondition {
      condition     = length(var.signature_config_rules) > 0 || length(var.baseline_model_config_anomaly_thresholds) > 0
      error_message = "At least one of signature_config_rules or baseline_model_config_anomaly_thresholds must be provided."
    }
  }
}
