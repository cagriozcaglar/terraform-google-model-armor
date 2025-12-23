# Google Cloud Model Armor Template Terraform Module

This module creates a Google Cloud Model Armor template to protect Vertex AI model endpoints from adversarial attacks. It allows for flexible configuration of policy rules, logging, and notifications.

Model Armor is a security feature for Vertex AI that helps protect your generative AI models from harm. It detects and blocks harmful inputs and can be configured to quarantine suspicious data for further analysis.

## Usage

Here is a basic example of how to use this module to create a Model Armor template.

```hcl
module "model_armor_template" {
  source  = "path/to/this/module"

  project_id   = "your-gcp-project-id"
  location     = "us-central1"
  template_id  = "my-secure-template"
  display_name = "My Secure Model Armor Template"
  description  = "A template to protect against prompt injection and jailbreaking."

  labels = {
    env       = "production"
    team      = "security"
  }

  // Enable logging and notifications
  enable_logging            = true
  log_destination_bigquery  = "projects/your-gcp-project-id/datasets/model_armor_logs"
  notification_pubsub_topic = "projects/your-gcp-project-id/topics/model_armor_alerts"

  // Define a set of policy rules
  policy_rules = [
    {
      action            = "BLOCK"
      attack_signatures = ["PROMPT_INJECTION"]
      description       = "Block prompt injection attempts"
      sensitivity_level = "HIGH"
    },
    {
      action                 = "BLOCK_AND_QUARANTINE"
      attack_signatures      = ["JAILBREAKING"]
      description            = "Quarantine jailbreaking attempts"
      quarantine_destination = "gs://your-quarantine-bucket/jailbreaking/"
    },
    {
      action            = "ALERT"
      attack_signatures = ["INSULTS"]
      description       = "Alert on insulting language"
      sensitivity_level = "MEDIUM"
    }
  ]
}
```

## Requirements

Before this module can be used on a project, you must ensure that the following APIs are enabled:

*   [Vertex AI API](https://console.cloud.google.com/apis/library/aiplatform.googleapis.com): `aiplatform.googleapis.com`

The service account or user running Terraform must have the following roles:

*   `roles/aiplatform.admin` on the project.

### Software

The following software is required:

*   [Terraform](https://www.terraform.io/downloads.html) >= 1.3
*   [Terraform Provider for GCP](https://github.com/hashicorp/terraform-provider-google) >= 5.3

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_rule_action"></a> [default\_rule\_action](#input\_default\_rule\_action) | The default action to take when no rules match a request. Valid values are 'ALLOW' or 'BLOCK'. | `string` | `"ALLOW"` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description for the Model Armor template. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the Model Armor template. | `string` | n/a | yes |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Whether to enable logging of detected threats. If true, `log_destination_bigquery` must be provided. | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of key/value labels to apply to the Model Armor template. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The GCP region where the Model Armor template will be created. | `string` | n/a | yes |
| <a name="input_log_destination_bigquery"></a> [log\_destination\_bigquery](#input\_log\_destination\_bigquery) | The BigQuery dataset to write threat logs to. Required if `enable_logging` is true. Format: `projects/{project}/datasets/{dataset}`. | `string` | `null` | no |
| <a name="input_notification_pubsub_topic"></a> [notification\_pubsub\_topic](#input\_notification\_pubsub\_topic) | The full resource name of the Pub/Sub topic to send security event notifications to. Format: `projects/{project}/topics/{topic}`. | `string` | `null` | no |
| <a name="input_policy_rules"></a> [policy\_rules](#input\_policy\_rules) | A list of policy rules to apply. Each rule defines a set of conditions (attack signatures) and an action to take upon match. | <pre>list(object({<br>    description            = optional(string)<br>    action                 = string<br>    attack_signatures      = list(string)<br>    sensitivity_level      = optional(string, "MEDIUM")<br>    quarantine_destination = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID where the Model Armor template will be created. If not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_template_id"></a> [template\_id](#input\_template\_id) | The ID of the Model Armor template. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_time"></a> [create\_time](#output\_create\_time) | The creation timestamp of the Model Armor template. |
| <a name="output_id"></a> [id](#output\_id) | The full resource ID of the created Model Armor template. |
| <a name="output_name"></a> [name](#output\_name) | The full resource name of the Model Armor template. |
| <a name="output_update_time"></a> [update\_time](#output\_update\_time) | The last update timestamp of the Model Armor template. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for information on contributing to this module.
