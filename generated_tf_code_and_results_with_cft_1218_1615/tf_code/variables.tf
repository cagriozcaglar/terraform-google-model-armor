# The project ID where the security policy will be created.
variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project where the Model Armor security policy will be created. If not provided, the provider project is used."
  default     = null
}

# The name of the security policy.
variable "name" {
  type        = string
  description = "The name of the Model Armor security policy."
  default     = "model-armor-policy-example"
}

# A list of rules to apply to the security policy.
# Each rule object can have one of 'match_ip_ranges' or 'match_expression' to define the match condition.
variable "rules" {
  type = list(object({
    description      = optional(string, "Terraform-managed security rule.")
    priority         = number
    action           = string
    match_ip_ranges  = optional(list(string))
    match_expression = optional(string)
    rate_limit_options = optional(object({
      conform_action = string
      exceed_action  = string
      rate_limit_threshold = object({
        count        = number
        interval_sec = number
      })
      ban_duration_sec = optional(number)
      enforce_on_key   = optional(string, "IP")
    }))
  }))
  description = <<-EOD
    A list of security rules to apply. Each rule must have a unique priority.
    A rule must specify exactly one of `match_ip_ranges` or `match_expression`.
    - `match_ip_ranges`: A list of CIDR ranges to match. Use `["*"]` to match all traffic.
    - `match_expression`: A CEL expression for advanced matching. For predefined rules like WAF, use an expression like `evaluatePreconfiguredExpr('owasp-crs-v33-stable')`.
    - `rate_limit_options`: Required for `rate_based_ban` or `throttle` actions.
  EOD
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for rule in var.rules :
      (rule.match_ip_ranges == null || rule.match_expression == null)
    ])
    error_message = "A rule cannot have both 'match_ip_ranges' and 'match_expression' defined simultaneously."
  }
  validation {
    condition = alltrue([
      for rule in var.rules :
      (rule.match_ip_ranges != null || rule.match_expression != null)
    ])
    error_message = "Each rule must have either 'match_ip_ranges' or 'match_expression' defined."
  }
}

# An optional description of the security policy.
variable "description" {
  type        = string
  description = "An optional description for the Model Armor security policy."
  default     = null
}

# The action for the default rule.
variable "default_rule_action" {
  type        = string
  description = "The action for the default rule, which applies to all traffic not matched by other rules. This rule has the lowest priority. Must be 'allow' or 'deny'."
  default     = "allow"

  validation {
    condition     = contains(["allow", "deny"], var.default_rule_action)
    error_message = "The default rule action must be either 'allow' or 'deny'."
  }
}
