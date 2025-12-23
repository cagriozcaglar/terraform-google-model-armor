# This variable defines a detailed description of the Model Armor template's purpose.
variable "description" {
  description = "A detailed description of the Model Armor template's purpose."
  type        = string
  default     = null
}

# This variable defines the user-friendly name for the Model Armor template.
variable "display_name" {
  description = "The user-friendly name for the Model Armor template."
  type        = string
}

# This variable holds the configuration for the input validation policy using safety attributes to block harmful content.
variable "input_validation_safety_attributes" {
  description = "Configuration for the input validation policy, which blocks harmful content. Set to null to disable. Allowed values for each attribute are 'BLOCKING_SCORE_UNSPECIFIED', 'BLOCK_NONE', 'BLOCK_LOW_AND_ABOVE', 'BLOCK_MEDIUM_AND_ABOVE', 'BLOCK_HIGH'."
  type = object({
    toxicity          = optional(string)
    sexually_explicit = optional(string)
    hate_speech       = optional(string)
    dangerous_content = optional(string)
  })
  default = null
}

# This variable specifies the GCP location where the Model Armor template will be created.
variable "location" {
  description = "The GCP location where the Model Armor template will be created."
  type        = string
}

# This variable holds the configuration for logging detected incidents to a Pub/Sub topic.
variable "logging_config" {
  description = "Configuration for logging detected incidents to a Pub/Sub topic. Set to null to disable."
  type = object({
    enabled         = bool
    log_destination = optional(object({
      pubsub_topic = string
    }))
  })
  default = null
}

# This variable holds the configuration for the output scrubbing policy, which detects and redacts PII.
variable "output_scrubbing_pii_detection" {
  description = "Configuration for the output scrubbing policy, which detects and redacts PII. Set to null to disable."
  type = object({
    info_types         = optional(list(string))
    redaction_strategy = optional(string)
  })
  default = null

  validation {
    condition     = var.output_scrubbing_pii_detection == null || var.output_scrubbing_pii_detection.redaction_strategy == null || contains(["REDACTION_STRATEGY_UNSPECIFIED", "REPLACE_WITH_INFO_TYPE", "REDACT"], var.output_scrubbing_pii_detection.redaction_strategy)
    error_message = "Allowed values for redaction_strategy are 'REDACTION_STRATEGY_UNSPECIFIED', 'REPLACE_WITH_INFO_TYPE', or 'REDACT'."
  }
}

# This variable specifies the GCP project ID where the Model Armor template will be created.
variable "project_id" {
  description = "The GCP project ID where the Model Armor template will be created."
  type        = string
}

# This variable defines the unique identifier for the Model Armor template.
variable "template_id" {
  description = "The unique identifier for the Model Armor template. This value is used for the 'name' argument of the resource."
  type        = string
}

# This variable holds the configuration for the threat detection policy against adversarial attacks and prompt injection.
variable "threat_detection_policy" {
  description = "Configuration for the threat detection policy against adversarial attacks and prompt injection. Set to null to disable."
  type = object({
    adversarial_attack_detection = optional(object({
      enabled           = bool
      sensitivity_level = optional(string)
    }))
    prompt_injection_detection = optional(object({
      enabled = bool
    }))
  })
  default = null

  validation {
    condition     = var.threat_detection_policy == null || var.threat_detection_policy.adversarial_attack_detection == null || var.threat_detection_policy.adversarial_attack_detection.sensitivity_level == null || contains(["SENSITIVITY_LEVEL_UNSPECIFIED", "LOW", "MEDIUM", "HIGH"], var.threat_detection_policy.adversarial_attack_detection.sensitivity_level)
    error_message = "Allowed values for sensitivity_level are 'SENSITIVITY_LEVEL_UNSPECIFIED', 'LOW', 'MEDIUM', or 'HIGH'."
  }
}
