# Vertex AI Model Armor Template Terraform Module

This module manages a [Vertex AI Model Armor Template](https://cloud.google.com/vertex-ai/docs/model-monitoring/model-armor-overview) (`google_model_armor_template`) in Google Cloud.

Model Armor helps protect your Vertex AI models from misuse and attacks by providing a configurable security policy layer. This module creates a reusable template that defines a security policy, which can then be applied to one or more Vertex AI Endpoints.

The policy can include:
- **Signature-based detection**: Rules that block requests based on predefined attack signatures.
- **Anomaly detection**: Rules that identify unusual input based on a baseline model.

## Usage

The following example creates a Model Armor template with both signature-based rules and an anomaly detection threshold.

```hcl
module "model_armor_template" {
  source      = "./" # Or a path to your module
  project_id  = "your-gcp-project-id"
  location    = "us-central1"
  template_id = "my-secure-template"

  display_name = "My Secure Model Template"
  description  = "A template to protect against common attacks and high-similarity inputs."

  # Define rules based on predefined attack signatures
  signature_config_rules = [
    {
      action       = "BLOCK"
      priority     = 100
      signature_id = "google-vertex-co-ja-v1" # Jailbreak common
      description  = "Block common jailbreak attempts"
    },
    {
      action       = "BLOCK"
      priority     = 200
      signature_id = "google-vertex-pi-v1" # Personally Identifiable Information
      description  = "Block requests containing PII"
    }
  ]

  # Define thresholds for anomaly detection
  baseline_model_config_anomaly_thresholds = [
    {
      anomaly_type = "high_similarity"
      threshold    = 0.95
    }
  ]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.37.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_baseline_model_config_anomaly_thresholds"></a> [baseline\_model\_config\_anomaly\_thresholds](#input\_baseline\_model\_config\_anomaly\_thresholds) | A list of anomaly detection thresholds. Each threshold specifies an anomaly type and a value. | <pre>list(object({<br>    anomaly_type = string<br>    threshold    = number<br>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description for the Model Armor template. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | An optional display name for the Model Armor template. If not set, template\_id will be used. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The GCP region for the Model Armor template. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the GCP project where the Model Armor template will be created. | `string` | n/a | yes |
| <a name="input_signature_config_rules"></a> [signature\_config\_rules](#input\_signature\_config\_rules) | A list of signature rules to apply. Each rule specifies an action, priority, signature ID, and optional description. | <pre>list(object({<br>    action       = string<br>    priority     = number<br>    signature_id = string<br>    description  = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | The user-provided ID of the Model Armor template. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The full resource ID of the created Model Armor template. |
| <a name="output_name"></a> [name](#output\_name) | The resource name of the Model Armor template. |
| <a name="output_template_id"></a> [template\_id](#output\_template\_id) | The user-provided ID of the Model Armor template. |
<!-- END_TF_DOCS -->
