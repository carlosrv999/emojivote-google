terraform {
  required_version = "~> 1.3.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.41.0"
    }
  }
}
