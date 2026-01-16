/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  project = var.project_id
}

module "model_armor_template" {
  source      = "../../"
  project_id  = var.project_id
  location    = "us-central1"
  template_id = "my-comprehensive-template"

  labels = {
    env      = "development"
    team     = "ai-safety"
    priority = "high"
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
        },
        {
          filter_type = "SEXUALLY_EXPLICIT"
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
    enforcement_type                   = "INSPECT_AND_BLOCK"
    log_sanitize_operations            = true
    log_template_operations            = true
    ignore_partial_invocation_failures = false
    custom_prompt_safety_error_code    = 400
    custom_prompt_safety_error_message = "Your prompt has been blocked due to a safety policy violation."
  }
}
