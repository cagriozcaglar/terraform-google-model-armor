output "create_time" {
  description = "The creation timestamp of the Model Armor template."
  value       = google_model_armor_template.model_armor.create_time
}

output "id" {
  description = "The full resource ID of the created Model Armor template."
  value       = google_model_armor_template.model_armor.id
}

output "name" {
  description = "The full resource name of the Model Armor template."
  value       = google_model_armor_template.model_armor.name
}

output "update_time" {
  description = "The last update timestamp of the Model Armor template."
  value       = google_model_armor_template.model_armor.update_time
}
