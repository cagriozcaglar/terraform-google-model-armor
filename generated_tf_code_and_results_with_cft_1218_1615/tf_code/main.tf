# Locals block to separate rules based on their match type.
# This is necessary because a rule's `match` block cannot contain both `config` (for IP ranges) and `expr` (for expressions).
locals {
  # Filters for rules that use IP-based matching.
  ip_rules = [
    for rule in var.rules : rule if rule.match_ip_ranges != null
  ]
  # Filters for rules that use expression-based matching.
  expression_rules = [
    for rule in var.rules : rule if rule.match_expression != null
  ]
}

# This resource defines a Google Cloud Armor security policy, which serves as the "Model_Armor"
# defense layer to protect ML model endpoints from various web-based threats.
resource "google_compute_security_policy" "model_armor_policy" {
  # Specifies that this resource should be managed by the Google Beta provider.
  provider = google-beta

  # The GCP project where the policy is created.
  project = var.project_id
  # The user-defined name for the policy.
  name = var.name
  # The user-defined description for the policy.
  description = var.description

  # Default rule that applies to any traffic not matching the custom rules.
  # It is assigned the lowest possible priority to ensure it is evaluated last.
  rule {
    # The action to take for the default rule, typically 'allow'.
    action = var.default_rule_action
    # The lowest possible priority.
    priority = 2147483647
    # Matches all IP addresses.
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    # A description for the default rule.
    description = "Default rule to ${var.default_rule_action} all unmatched traffic."
  }

  # This dynamic block creates rules based on IP address matching.
  dynamic "rule" {
    for_each = local.ip_rules
    content {
      # The action to perform when the rule is matched (e.g., 'allow', 'deny', 'rate_based_ban').
      action = rule.value.action
      # The priority of the rule, determining the order of evaluation (lower number is higher priority).
      priority = rule.value.priority
      # A description for this specific rule.
      description = rule.value.description

      # The match condition for the rule, based on source IP ranges.
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = rule.value.match_ip_ranges
        }
      }

      # This dynamic block adds rate limiting options if specified for the rule.
      # It is only included for actions like 'rate_based_ban' or 'throttle'.
      dynamic "rate_limit_options" {
        for_each = rule.value.rate_limit_options != null ? [rule.value.rate_limit_options] : []
        content {
          # Action to take when requests are within the limit.
          conform_action = rate_limit_options.value.conform_action
          # Action to take when requests exceed the limit.
          exceed_action = rate_limit_options.value.exceed_action
          # The key to enforce rate limiting on (e.g., 'IP', 'HTTP_HEADER').
          enforce_on_key = lookup(rate_limit_options.value, "enforce_on_key", null)
          # The duration in seconds to ban the client after the limit is exceeded.
          ban_duration_sec = lookup(rate_limit_options.value, "ban_duration_sec", null)
          # The threshold for rate limiting.
          rate_limit_threshold {
            # Number of requests.
            count = rate_limit_options.value.rate_limit_threshold.count
            # Time interval in seconds.
            interval_sec = rate_limit_options.value.rate_limit_threshold.interval_sec
          }
        }
      }
    }
  }

  # This dynamic block creates rules based on Common Expression Language (CEL) expressions.
  # This is used for advanced matching and predefined WAF rules.
  dynamic "rule" {
    for_each = local.expression_rules
    content {
      # The action to perform when the rule is matched (e.g., 'allow', 'deny').
      action = rule.value.action
      # The priority of the rule, determining the order of evaluation.
      priority = rule.value.priority
      # A description for this specific rule.
      description = rule.value.description

      # The match condition for the rule, based on a CEL expression.
      match {
        expr {
          expression = rule.value.match_expression
        }
      }

      # This dynamic block adds rate limiting options if specified for the rule.
      dynamic "rate_limit_options" {
        for_each = rule.value.rate_limit_options != null ? [rule.value.rate_limit_options] : []
        content {
          # Action to take when requests are within the limit.
          conform_action = rate_limit_options.value.conform_action
          # Action to take when requests exceed the limit.
          exceed_action = rate_limit_options.value.exceed_action
          # The key to enforce rate limiting on.
          enforce_on_key = lookup(rate_limit_options.value, "enforce_on_key", null)
          # The duration in seconds to ban the client after the limit is exceeded.
          ban_duration_sec = lookup(rate_limit_options.value, "ban_duration_sec", null)
          # The threshold for rate limiting.
          rate_limit_threshold {
            # Number of requests.
            count = rate_limit_options.value.rate_limit_threshold.count
            # Time interval in seconds.
            interval_sec = rate_limit_options.value.rate_limit_threshold.interval_sec
          }
        }
      }
    }
  }
}
