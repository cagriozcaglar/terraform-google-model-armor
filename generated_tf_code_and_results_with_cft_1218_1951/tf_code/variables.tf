variable "filter_config" {
  description = "The policy configuration for the Model Armor template. A template must have exactly one policy, which is defined by this configuration."
  type = object({
    display_name = string
    description  = optional(string, null)
    detection_rules = optional(list(object({
      signature_id = string
      action       = string
      sensitivity  = string
      topic_filter = optional(object({
        allowed_topics = optional(list(string))
        blocked_topics = optional(list(string))
      }), null)
    })), [])
  })
}

variable "location" {
  description = "The location for the Model Armor Template. This is a global resource and the value should be 'global'."
  type        = string
  default     = "global"
}

variable "name" {
  description = "The user-provided ID of the Model Armor template. It must be unique within the location."
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Cloud project in which to create the resource."
  type        = string
}
