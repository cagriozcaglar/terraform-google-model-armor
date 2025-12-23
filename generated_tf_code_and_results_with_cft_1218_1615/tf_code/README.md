# Google Cloud Armor Security Policy Module

This module simplifies the creation and management of Google Cloud Armor security policies. It is designed to be a flexible "Model Armor" layer for protecting backend services, such as ML model endpoints, from various web-based threats.

Key features include:
- Easy configuration of IP-based allow/deny rules.
- Support for advanced matching using Common Expression Language (CEL).
- Integration with preconfigured WAF rules (e.g., OWASP Top 10).
- Built-in support for rate-limiting rules.
- A configurable default rule for unmatched traffic.

This module is compatible with Terraform 1.0 and later.

## Usage

### Basic Example

A minimal security policy with a default 'allow' rule.

```terraform
module "model_armor" {
  source     = "./path/to/module"
  project_id = "your-gcp-project-id"
  name       = "my-basic-armor-policy"
}
```

### Example with Custom Rules

This example demonstrates various rule types: denying a specific IP range, applying a preconfigured WAF rule, and rate-limiting requests.

```terraform
module "model_armor_with_rules" {
  source      = "./path/to/module"
  project_id  = "your-gcp-project-id"
  name        = "my-comprehensive-armor-policy"
  description = "A policy with WAF, IP deny, and rate limiting."

  rules = [
    // Rule 1: Deny traffic from a specific IP range
    {
      priority        = 1000
      description     = "Block traffic from a known bad IP range."
      action          = "deny(403)"
      match_ip_ranges = ["192.0.2.0/24"]
    },

    // Rule 2: Apply a preconfigured WAF rule to mitigate SQL injection
    {
      priority         = 1100
      description      = "OWASP Top 10: SQLi Protection"
      action           = "deny(403)"
      match_expression = "evaluatePreconfiguredExpr('sqli-stable')"
    },

    // Rule 3: Rate-limit requests from any single IP
    {
      priority        = 1200
      description     = "Rate limit requests to 100 per 5 minutes."
      action          = "rate_based_ban"
      match_ip_ranges = ["*"] // Apply this rule to all traffic
      rate_limit_options = {
        conform_action = "allow"
        exceed_action  = "deny(429)"
        rate_limit_threshold = {
          count        = 100
          interval_sec = 300 // 5 minutes
        }
        ban_duration_sec = 900 // Ban for 15 minutes
        enforce_on_key   = "IP"
      }
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_id` | The ID of the Google Cloud project where the Model Armor security policy will be created. If not provided, the provider project is used. | `string` | `null` | no |
| `name` | The name of the Model Armor security policy. | `string` | `"model-armor-policy-example"` | no |
| `rules` | A list of security rules to apply. Each rule must have a unique priority. See the [Rule Object Structure](#rule-object-structure) section for details. | `list(object)` | `[]` | no |
| `description` | An optional description for the Model Armor security policy. | `string` | `null` | no |
| `default_rule_action` | The action for the default rule, which applies to all traffic not matched by other rules. This rule has the lowest priority. Must be 'allow' or 'deny'. | `string` | `"allow"` | no |

### Rule Object Structure

The `rules` variable is a list of objects, where each object has the following attributes:

| Attribute | Description | Type | Required |
|---|---|:---:|:---:|
| `priority` | The priority of the rule, determining the order of evaluation (lower number is higher priority). Must be a unique integer between 0 and 2147483646. | `number` | yes |
| `action` | The action to perform when the rule is matched (e.g., `allow`, `deny(403)`, `rate_based_ban`, `throttle`). | `string` | yes |
| `description` | An optional description for the security rule. | `string` | no |
| `match_ip_ranges` | A list of CIDR ranges to match. Use `["*"]` to match all traffic. | `list(string)` | conditional |
| `match_expression` | A CEL expression for advanced matching. For predefined rules like WAF, use an expression like `evaluatePreconfiguredExpr('owasp-crs-v33-stable')`. | `string` | conditional |
| `rate_limit_options` | A block of rate limiting options. Required for `rate_based_ban` or `throttle` actions. See below for its structure. | `object` | no |

**Note:** A rule must specify exactly one of `match_ip_ranges` or `match_expression`.

The `rate_limit_options` object has the following attributes:

| Attribute | Description | Type | Required |
|---|---|:---:|:---:|
| `conform_action` | Action to take when requests are within the limit (e.g., `allow`). | `string` | yes |
| `exceed_action` | Action to take when requests exceed the limit (e.g., `deny(429)`). | `string` | yes |
| `rate_limit_threshold` | The threshold for rate limiting, containing `count` and `interval_sec`. | `object` | yes |
| `ban_duration_sec` | The duration in seconds to ban the client after the limit is exceeded. | `number` | no |
| `enforce_on_key` | The key to enforce rate limiting on (e.g., `IP`, `HTTP_HEADER`). Defaults to `IP`. | `string` | no |


## Outputs

| Name | Description |
|---|---|
| `id` | The fully qualified ID of the security policy. |
| `name` | The name of the security policy. |
| `self_link` | The URI of the created security policy. |

## Requirements

### Terraform

- Terraform v1.0 or later

### Providers

| Name | Version |
|------|---------|
| google-beta | >= 4.23.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_security_policy.model_armor_policy](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/compute_security_policy) | resource |
