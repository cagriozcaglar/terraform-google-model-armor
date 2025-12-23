# Vertex AI Model Armor Template

This module allows you to create and manage a [Vertex AI Model Armor Template](https://cloud.google.com/vertex-ai/docs/model-monitoring/model-armor-overview). Model Armor templates are reusable sets of security policies that can be attached to Vertex AI Endpoints to help protect your models from misuse and adversarial attacks.

This module allows you to configure the following security policies:
*   **Threat Detection:** Protects against adversarial attacks and prompt injection.
*   **Input Validation:** Blocks harmful content based on safety filters like toxicity, hate speech, etc.
*   **Output Scrubbing:** Detects and redacts Personally Identifiable Information (PII) from model outputs.
*   **Logging:** Configures logging of detected security incidents to a Pub/Sub topic.

At least one security policy (`threat_detection_policy`, `input_validation_safety_attributes`, or `output_scrubbing_pii_detection`) must be configured.

## Usage

Here is a basic example of how to use this module to create a Model Armor template with threat detection and input validation policies enabled.

```hcl
module "model_armor_template" {
  source = "./" # Replace with module source

  project_id   = "your-gcp-project-id"
  location     = "us-central1"
  template_id  = "my-secure-template"
  display_name = "My Secure Model Template"
  description  = "A template with threat detection and input validation."

  threat_detection_policy = {
    adversarial_attack_detection = {
      enabled           = true
      sensitivity_level = "MEDIUM"
    }
    prompt_injection_detection = {
      enabled = true
    }
  }

  input_validation_safety_attributes = {
    toxicity          = "BLOCK_MEDIUM_AND_ABOVE"
    hate_speech       = "BLOCK_LOW_AND_ABOVE"
    sexually_explicit = "BLOCK_MEDIUM_AND_ABOVE"
    dangerous_content = "BLOCK_MEDIUM_AND_ABOVE"
  }

  logging_config = {
    enabled = true
    log_destination = {
      pubsub_topic = "projects/your-gcp-project-id/topics/model-armor-logs"
    }
  }
}
```

## Requirements

The following requirements are needed to use this module:

### Software

*   [Terraform](https://www.terraform.io/downloads.html) >= 1.3
*   [Terraform Provider for Google Cloud](https://github.com/hashicorp/terraform-provider-google) ~> 5.41

### APIs

The following APIs must be enabled on the target project:
*   Vertex AI API: `vertexai.googleapis.com`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `display_name` | The user-friendly name for the Model Armor template. | `string` | n/a | yes |
| `location` | The GCP location where the Model Armor template will be created. | `string` | n/a | yes |
| `project_id` | The GCP project ID where the Model Armor template will be created. | `string` | n/a | yes |
| `template_id` | The unique identifier for the Model Armor template. This value is used for the 'name' argument of the resource. | `string` | n/a | yes |
| `description` | A detailed description of the Model Armor template's purpose. | `string` | `null` | no |
| `input_validation_safety_attributes` | Configuration for the input validation policy, which blocks harmful content. Set to `null` to disable. Allowed values for each attribute are `BLOCKING_SCORE_UNSPECIFIED`, `BLOCK_NONE`, `BLOCK_LOW_AND_ABOVE`, `BLOCK_MEDIUM_AND_ABOVE`, `BLOCK_HIGH`. | <pre>object({<br>    toxicity          = optional(string)<br>    sexually_explicit = optional(string)<br>    hate_speech       = optional(string)<br>    dangerous_content = optional(string)<br>  })</pre> | `null` | no |
| `logging_config` | Configuration for logging detected incidents to a Pub/Sub topic. Set to `null` to disable. The `pubsub_topic` should be the full resource name, e.g., `projects/my-project/topics/my-topic`. | <pre>object({<br>    enabled         = bool<br>    log_destination = optional(object({<br>      pubsub_topic = string<br>    }))<br>  })</pre> | `null` | no |
| `output_scrubbing_pii_detection` | Configuration for the output scrubbing policy, which detects and redacts PII. Set to `null` to disable. Allowed values for `redaction_strategy` are `REDACTION_STRATEGY_UNSPECIFIED`, `REPLACE_WITH_INFO_TYPE`, or `REDACT`. | <pre>object({<br>    info_types         = optional(list(string))<br>    redaction_strategy = optional(string)<br>  })</pre> | `null` | no |
| `threat_detection_policy` | Configuration for the threat detection policy against adversarial attacks and prompt injection. Set to `null` to disable. Allowed values for `sensitivity_level` are `SENSITIVITY_LEVEL_UNSPECIFIED`, `LOW`, `MEDIUM`, or `HIGH`. | <pre>object({<br>    adversarial_attack_detection = optional(object({<br>      enabled           = bool<br>      sensitivity_level = optional(string)<br>    }))<br>    prompt_injection_detection = optional(object({<br>      enabled = bool<br>    }))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `create_time` | The creation timestamp of the Model Armor template. |
| `id` | The unique ID of the Model Armor template. |
| `name` | The full resource name of the Model Armor template. |
| `update_time` | The last update timestamp of the Model Armor template. |
