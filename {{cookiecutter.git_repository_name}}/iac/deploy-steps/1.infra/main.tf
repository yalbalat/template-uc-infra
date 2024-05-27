terraform {
  required_version = ">= 1.3.4, < 2.0.0"
  backend "gcs" {
    prefix = "{{cookiecutter.use_case}}/"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.0.0, <6.0.0"
    }
  }
}

provider "google" {
  project = local.project_id
}

locals {
  env        = var.env
  project_id = var.project_id
}

# Create initial ressources (Cloud build triggers, activates apis, creates a custom sa to deploy bq queries)
#-- As a prerequisite you still need a repo admin to connect the repo to your project via the GUI.
#-- Start by commenting the usecase module and applying the init module
module "init" {
  source               = "./../../modules/init"
  config_path          = "./../../../config"
  dataform_config_file = "./../../../dataform.json"
  project_id           = local.project_id
  env                  = local.env
}

module "{{cookiecutter.use_case}}" {
  source               = "./../../modules/{{cookiecutter.use_case}}"
  config_path          = "./../../../config"
  dataform_config_file = "./../../../dataform.json"
  env                  = local.env
  project_id           = local.project_id
}
