# This output exposes the creation timestamp of the Model Armor template.
output "create_time" {
  description = "The creation timestamp of the Model Armor template."
  value       = google_model_armor_template.main.create_time
}

# This output exposes the unique identifier of the created Model Armor template.
output "id" {
  description = "The unique ID of the Model Armor template."
  value       = google_model_armor_template.main.id
}

# This output exposes the full resource name of the created Model Armor template.
output "name" {
  description = "The full resource name of the Model Armor template."
  value       = google_model_armor_template.main.name
}

# This output exposes the timestamp when the Model Armor template was last updated.
output "update_time" {
  description = "The last update timestamp of the Model Armor template."
  value       = google_model_armor_template.main.update_time
}
