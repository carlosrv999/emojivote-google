terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.41.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "docker" {
  registry_auth {
    config_file = pathexpand("~/.docker/config.json")
    address     = "us-central1-docker.pkg.dev"
  }
}
