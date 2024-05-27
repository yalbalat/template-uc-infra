terraform {
  required_version = ">= 1.3.4, < 2.0.0"
  backend "gcs" {
    prefix = "{{cookiecutter.use_case}}-am/"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.0.0, <6.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

module "accessmanagement" {
  source               = "./../../modules/accessmanagement"
  config_path          = "./../../../config"
  dataform_config_file = "./../../../dataform.json"
  project_id           = var.project_id
  env                  = var.env
}
