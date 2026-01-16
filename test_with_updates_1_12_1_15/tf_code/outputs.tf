# This file defines the outputs of the Terraform module.
# Outputs are values that are exposed to the user after the module is applied.
output "name" {
  description = "The full resource name of the Model Armor Template."
  value       = google_model_armor_template.main.name
}

output "id" {
  description = "The unique identifier for the Model Armor Template, in the format projects/{{project}}/locations/{{location}}/templates/{{template_id}}."
  value       = google_model_armor_template.main.id
}

output "create_time" {
  description = "The creation timestamp of the Model Armor Template."
  value       = google_model_armor_template.main.create_time
}

output "update_time" {
  description = "The last update timestamp of the Model Armor Template."
  value       = google_model_armor_template.main.update_time
}
