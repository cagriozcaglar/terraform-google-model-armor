variable "default_rule_action" {
  description = "The default action to take when no rules match a request. Valid values are 'ALLOW' or 'BLOCK'."
  type        = string
  default     = "ALLOW"

  validation {
    condition     = contains(["ALLOW", "BLOCK"], var.default_rule_action)
    error_message = "The default_rule_action must be either 'ALLOW' or 'BLOCK'."
  }
}

variable "description" {
  description = "An optional description for the Model Armor template."
  type        = string
  default     = null
}

variable "display_name" {
  description = "The display name of the Model Armor template."
  type        = string
}

variable "enable_logging" {
  description = "Whether to enable logging of detected threats. If true, `log_destination_bigquery` must be provided."
  type        = bool
  default     = false
}

variable "labels" {
  description = "A map of key/value labels to apply to the Model Armor template."
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "The GCP region where the Model Armor template will be created."
  type        = string
}

variable "log_destination_bigquery" {
  description = "The BigQuery dataset to write threat logs to. Required if `enable_logging` is true. Format: `projects/{project}/datasets/{dataset}`."
  type        = string
  default     = null

  validation {
    condition     = var.log_destination_bigquery == null ? true : can(regex("^projects/.+/datasets/.+$", var.log_destination_bigquery))
    error_message = "The log_destination_bigquery must be in the format 'projects/{project}/datasets/{dataset}'."
  }
}

variable "notification_pubsub_topic" {
  description = "The full resource name of the Pub/Sub topic to send security event notifications to. Format: `projects/{project}/topics/{topic}`."
  type        = string
  default     = null

  validation {
    condition     = var.notification_pubsub_topic == null ? true : can(regex("^projects/.+/topics/.+$", var.notification_pubsub_topic))
    error_message = "The notification_pubsub_topic must be in the format 'projects/{project}/topics/{topic}'."
  }
}

variable "policy_rules" {
  description = "A list of policy rules to apply. Each rule defines a set of conditions (attack signatures) and an action to take upon match."
  type = list(object({
    description            = optional(string)
    action                 = string
    attack_signatures      = list(string)
    sensitivity_level      = optional(string, "MEDIUM")
    quarantine_destination = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.policy_rules : contains(["ALLOW", "ALERT", "BLOCK", "BLOCK_AND_QUARANTINE"], rule.action)
    ])
    error_message = "The 'action' attribute for each rule must be one of 'ALLOW', 'ALERT', 'BLOCK', or 'BLOCK_AND_QUARANTINE'."
  }
  validation {
    condition = alltrue([
      for rule in var.policy_rules : (rule.action == "BLOCK_AND_QUARANTINE" ? rule.quarantine_destination != null : true)
    ])
    error_message = "The 'quarantine_destination' must be set when the action is 'BLOCK_AND_QUARANTINE'."
  }
  validation {
    condition = alltrue([
      for rule in var.policy_rules : length(rule.attack_signatures) > 0
    ])
    error_message = "The 'attack_signatures' list must not be empty for any rule."
  }
}

variable "project_id" {
  description = "The GCP project ID where the Model Armor template will be created. If not provided, the provider project is used."
  type        = string
  default     = null
}

variable "template_id" {
  description = "The ID of the Model Armor template."
  type        = string
}
