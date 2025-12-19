output "id" {
  description = "The full resource ID of the created Model Armor template."
  value       = google_model_armor_template.this.id
}

output "name" {
  description = "The resource name of the Model Armor template."
  value       = google_model_armor_template.this.name
}

output "template_id" {
  description = "The user-provided ID of the Model Armor template."
  value       = google_model_armor_template.this.template_id
}
