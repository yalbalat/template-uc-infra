terraform {
  required_version = ">= 1.3.4, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.0.0, <6.0.0"
    }
  }
}
