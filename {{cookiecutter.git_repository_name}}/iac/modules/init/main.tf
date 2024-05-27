variable "project_id" { type = string }
variable "env" { type = string }
variable "config_path" { type = string }
variable "dataform_config_file" { type = string }

terraform {
  required_version = ">= 1.3.4, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.0.0, <6.0.0"
    }
  }
}

locals {
  general_config  = yamldecode(file("${var.config_path}/general.yaml"))
  dataform_config = jsondecode(file(var.dataform_config_file))

  usecase = replace(local.dataform_config["vars"]["use_case"], "_", "-")
}

resource "google_project_service" "apis" {
  for_each           = toset(local.general_config["apis_to_activate"])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "terraform-cloud-credentials" {
  secret_id = "terraform-cloud-credentials"
  replication {
    auto {
    }
  }
  depends_on = [
    google_project_service.apis
  ]
}

# Service account to get access to data from other GCP project
resource "google_service_account" "deploy" {
  project      = var.project_id
  account_id   = "${local.usecase}-sa-cloudbuild-${var.env}"
  description  = "Service account for deploying infrastructure on the project: ${local.usecase} (to be used instead of the default Cloud Build account)"
  display_name = "Cloud Build deploy service account"
}

output "deploy" {
  value = google_service_account.deploy.email
}


resource "google_cloudbuild_trigger" "tf-plan" {
  github {
    owner = local.general_config["git_organization_name"]
    name  = local.general_config["git_repository_name"]

    pull_request {
      branch = (var.env == "pd") ? "^(main)$" : "^(integration)$"
    }
  }

  disabled = strcontains(var.project_id, "sbx") ? true : false

  substitutions = {
    _APPLY_CHANGES = "false"
    _ENV           = var.env
    _REGION        = local.general_config["region"]
    _USECASE       = local.usecase
  }
  name            = "${local.usecase}-plan"
  filename        = "cloudbuild.yaml"
  service_account = google_service_account.deploy.id
}

resource "google_cloudbuild_trigger" "tf-apply" {
  github {
    owner = local.general_config["git_organization_name"]
    name  = local.general_config["git_repository_name"]

    push {
      branch = (var.env == "pd") ? "^(main)$" : "^(integration)$"
    }
  }

  disabled = strcontains(var.project_id, "sbx") ? true : false

  substitutions = {
    _APPLY_CHANGES = "true"
    _ENV           = var.env
    _REGION        = local.general_config["region"]
    _USECASE       = local.usecase
  }
  name            = "${local.usecase}-apply"
  filename        = "cloudbuild.yaml"
  service_account = google_service_account.deploy.id
}
