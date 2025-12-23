# The fully qualified ID of the Model Armor security policy.
output "id" {
  description = "The fully qualified ID of the security policy."
  value       = google_compute_security_policy.model_armor_policy.id
}

# The name of the Model Armor security policy.
output "name" {
  description = "The name of the security policy."
  value       = google_compute_security_policy.model_armor_policy.name
}

# The self_link of the Model Armor security policy.
output "self_link" {
  description = "The URI of the created security policy."
  value       = google_compute_security_policy.model_armor_policy.self_link
}
