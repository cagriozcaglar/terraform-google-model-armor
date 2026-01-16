# Terraform Google Model Armor Template Module

This module manages a [Google Cloud Model Armor Template](https://cloud.google.com/vertex-ai/docs/generative-ai/model-armor/overview) resource. Model Armor templates define a set of safety and security policies that can be applied to Large Language Models (LLMs) to detect and filter harmful or unwanted content in prompts and responses.

This module allows you to configure various filters, including:
*   Malicious URI detection
*   Prompt Injection (PI) and Jailbreaking detection
*   Responsible AI (RAI) filters for sensitive topics
*   Sensitive Data Protection (SDP) for PII

## Usage

Here is a basic example of how to use this module to create a Model Armor Template.

```hcl
module "model_armor_template" {
  source      = "<path-to-this-module>"
  project_id  = "your-gcp-project-id"
  location    = "us-central1"
  template_id = "my-secure-llm-template"

  labels = {
    env      = "production"
    team     = "ai-security"
  }

  filter_config = {
    malicious_uri_filter_settings = {
      filter_enforcement = "ENABLED"
    }
    pi_and_jailbreak_filter_settings = {
      confidence_level   = "HIGH"
      filter_enforcement = "ENABLED"
    }
    rai_settings = {
      rai_filters = [
        {
          filter_type      = "HATE_SPEECH"
          confidence_level = "MEDIUM_AND_ABOVE"
        },
        {
          filter_type      = "DANGEROUS"
          confidence_level = "HIGH"
        }
      ]
    }
    sdp_settings = {
      basic_config = {
        filter_enforcement = "ENABLED"
      }
    }
  }

  template_metadata = {
    enforcement_type        = "INSPECT_AND_BLOCK"
    log_sanitize_operations = true
    log_template_operations = true
  }
}
```

## Requirements

### Terraform
- [Terraform](https://www.terraform.io/downloads.html) >= 1.3

### Google Cloud Provider
- [Google Cloud Provider](https://registry.terraform.io/providers/hashicorp/google/latest) >= 5.0.0

### APIs
The following API must be enabled in the project where the resources are created:
- Vertex AI API: `vertexai.googleapis.com`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The ID of the project in which the Model Armor Template will be created. If not provided, the provider project will be used. | `string` | `null` | no |
| `location` | The location for the Model Armor Template. It identifies the resource within its parent collection. | `string` | `"us-central1"` | no |
| `template_id` | The user-provided ID of the Model Armor Template. | `string` | `"example-model-armor-template"` | no |
| `labels` | A map of labels to apply to the Model Armor Template. | `map(string)` | `{}` | no |
| `filter_config` | Configuration for the filters to be applied by the template. This block is required. See [Filter Config Structure](#filter-config-structure) for details. | `object(...)` | <pre>{<br>  malicious_uri_filter_settings = {<br>    filter_enforcement = "DISABLED"<br>  }<br>  pi_and_jailbreak_filter_settings = {<br>    filter_enforcement = "DISABLED"<br>  }<br>}</pre> | yes |
| `template_metadata` | Optional metadata for the Model Armor Template. See [Template Metadata Structure](#template-metadata-structure) for details. | `object(...)` | `null` | no |

---
### Filter Config Structure

The `filter_config` object defines the safety and security filters for the template. It has the following attributes:

*   `malicious_uri_filter_settings` (Optional): Configuration for the Malicious URI filter.
    *   `filter_enforcement` (Optional): Determines if the filter is enabled. Possible values are `"ENABLED"` or `"DISABLED"`. Defaults to `"DISABLED"`.
*   `pi_and_jailbreak_filter_settings` (Optional): Configuration for the Prompt Injection and Jailbreak Filter.
    *   `confidence_level` (Optional): The confidence level for the filter. Possible values are `"LOW_AND_ABOVE"`, `"MEDIUM_AND_ABOVE"`, `"HIGH"`. Defaults to `"MEDIUM_AND_ABOVE"`.
    *   `filter_enforcement` (Optional): Determines if the filter is enabled. Possible values are `"ENABLED"` or `"DISABLED"`. Defaults to `"DISABLED"`.
*   `rai_settings` (Optional): Configuration for Responsible AI Filters.
    *   `rai_filters` (Required): A list of objects, each defining a Responsible AI filter.
        *   `filter_type` (Required): The type of RAI filter. Possible values are `"SEXUALLY_EXPLICIT"`, `"HATE_SPEECH"`, `"HARASSMENT"`, `"DANGEROUS"`.
        *   `confidence_level` (Optional): The confidence level for the filter. Possible values are `"LOW_AND_ABOVE"`, `"MEDIUM_AND_ABOVE"`, `"HIGH"`. Defaults to `"MEDIUM_AND_ABOVE"`.
*   `sdp_settings` (Optional): Configuration for Sensitive Data Protection.
    *   `basic_config` (Optional): Basic SDP configuration.
        *   `filter_enforcement` (Optional): Determines if the basic SDP filter is enabled. Possible values are `"ENABLED"` or `"DISABLED"`. Defaults to `"DISABLED"`.
    *   `advanced_config` (Optional): Advanced SDP configuration using existing DLP templates.
        *   `inspect_template` (Optional): The resource name of the SDP inspect template.
        *   `deidentify_template` (Optional): The resource name of the SDP de-identify template.

### Template Metadata Structure

The `template_metadata` object defines operational settings for the template. It has the following attributes:

*   `enforcement_type` (Optional): The enforcement type for the template. Possible values are `"INSPECT_ONLY"` or `"INSPECT_AND_BLOCK"`.
*   `log_sanitize_operations` (Optional): If `true`, logs sanitize operations.
*   `log_template_operations` (Optional): If `true`, logs template CRUD operations.
*   `ignore_partial_invocation_failures` (Optional): If `true`, partial detector failures will be ignored.
*   `custom_prompt_safety_error_code` (Optional): Custom error code to return if a prompt trips Model Armor filters.
*   `custom_prompt_safety_error_message` (Optional): Custom error message to return if a prompt trips Model Armor filters.
*   `custom_llm_response_safety_error_code` (Optional): Custom error code to return if an LLM response trips Model Armor filters.
*   `custom_llm_response_safety_error_message` (Optional): Custom error message to return if an LLM response trips Model Armor filters.
*   `multi_language_detection` (Optional): Configuration for multi-language detection.
    *   `enable_multi_language_detection` (Required): If `true`, multi-language detection will be enabled.

## Outputs

| Name | Description |
|------|-------------|
| `name` | The full resource name of the Model Armor Template. |
| `id` | The unique identifier for the Model Armor Template, in the format `projects/{{project}}/locations/{{location}}/templates/{{template_id}}`. |
| `create_time` | The creation timestamp of the Model Armor Template. |
| `update_time` | The last update timestamp of the Model Armor Template. |
