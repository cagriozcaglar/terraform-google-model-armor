output "id" {
  description = "The unique identifier for the Model Armor template."
  value       = google_model_armor_template.model_armor.id
}

output "name" {
  description = "The resource name of the Model Armor template."
  value       = google_model_armor_template.model_armor.name
}
