# This file defines the input variables for the Terraform module.
# Each variable is documented with its type, description, and default value if applicable.
variable "project_id" {
  description = "The ID of the project in which the Model Armor Template will be created. If not provided, the provider project will be used."
  type        = string
  default     = null
}

variable "location" {
  description = "The location for the Model Armor Template. It identifies the resource within its parent collection."
  type        = string
  default     = "us-central1"
}

variable "template_id" {
  description = "The user-provided ID of the Model Armor Template."
  type        = string
  default     = "example-model-armor-template"
}

variable "labels" {
  description = "A map of labels to apply to the Model Armor Template."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "filter_config" {
  description = "Configuration for the filters to be applied by the template. This block is required."
  type = object({
    malicious_uri_filter_settings = optional(object({
      filter_enforcement = optional(string, "DISABLED")
    }))
    pi_and_jailbreak_filter_settings = optional(object({
      confidence_level   = optional(string, "MEDIUM_AND_ABOVE")
      filter_enforcement = optional(string, "DISABLED")
    }))
    rai_settings = optional(object({
      rai_filters = list(object({
        filter_type      = string
        confidence_level = optional(string, "MEDIUM_AND_ABOVE")
      }))
    }))
    sdp_settings = optional(object({
      basic_config = optional(object({
        filter_enforcement = optional(string, "DISABLED")
      }))
      advanced_config = optional(object({
        inspect_template    = optional(string)
        deidentify_template = optional(string)
      }))
    }))
  })
  default = {
    malicious_uri_filter_settings = {
      filter_enforcement = "DISABLED"
    }
    pi_and_jailbreak_filter_settings = {
      filter_enforcement = "DISABLED"
    }
  }

  validation {
    condition     = var.filter_config.rai_settings == null ? true : length(var.filter_config.rai_settings.rai_filters) > 0
    error_message = "The 'rai_filters' list cannot be empty if 'rai_settings' is specified."
  }
}

variable "template_metadata" {
  description = "Optional metadata for the Model Armor Template."
  type = object({
    enforcement_type                      = optional(string)
    log_sanitize_operations               = optional(bool)
    log_template_operations               = optional(bool)
    ignore_partial_invocation_failures    = optional(bool)
    custom_prompt_safety_error_code       = optional(number)
    custom_prompt_safety_error_message    = optional(string)
    custom_llm_response_safety_error_code = optional(number)
    custom_llm_response_safety_error_message = optional(string)
    multi_language_detection = optional(object({
      enable_multi_language_detection = bool
    }))
  })
  default  = null
  nullable = true
}
