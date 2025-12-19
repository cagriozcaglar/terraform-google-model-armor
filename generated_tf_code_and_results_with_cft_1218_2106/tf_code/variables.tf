variable "baseline_model_config_anomaly_thresholds" {
  description = "A list of anomaly detection thresholds. Each threshold specifies an anomaly type and a value."
  type = list(object({
    anomaly_type = string
    threshold    = number
  }))
  default = []
}

variable "description" {
  description = "An optional description for the Model Armor template."
  type        = string
  default     = null
}

variable "display_name" {
  description = "An optional display name for the Model Armor template. If not set, template_id will be used."
  type        = string
  default     = null
}

variable "location" {
  description = "The GCP region for the Model Armor template."
  type        = string
}

variable "project_id" {
  description = "The ID of the GCP project where the Model Armor template will be created."
  type        = string
}

variable "signature_config_rules" {
  description = "A list of signature rules to apply. Each rule specifies an action, priority, signature ID, and optional description."
  type = list(object({
    action       = string
    priority     = number
    signature_id = string
    description  = optional(string)
  }))
  default = []
}

variable "template_id" {
  description = "The user-provided ID of the Model Armor template."
  type        = string
}
