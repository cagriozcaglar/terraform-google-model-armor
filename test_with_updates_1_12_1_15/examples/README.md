# Simple Model Armor Template Example

This example demonstrates how to use the Model Armor Template module to create a comprehensive safety and security policy for a Large Language Model (LLM) in Google Cloud Vertex AI.

The example creates a `google_model_armor_template` resource with the following configurations:
-   **Malicious URI Filter**: Enabled to block harmful links.
-   **Prompt Injection & Jailbreak Filter**: Enabled with a high confidence threshold to prevent malicious prompt manipulation.
-   **Responsible AI (RAI) Filters**: Enabled for "Hate Speech", "Dangerous", and "Sexually Explicit" content.
-   **Sensitive Data Protection (SDP)**: Basic configuration is enabled to detect common PII.
-   **Template Metadata**: Configured to `INSPECT_AND_BLOCK` harmful content, enable logging, and provide custom error messages.

## How to use

### Prerequisites

1.  Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2.  Configure your Google Cloud credentials. See the [Terraform Google Provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication) for guidance.
