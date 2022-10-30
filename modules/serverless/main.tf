data "google_compute_default_service_account" "default" {}

resource "google_cloud_run_service" "initdb" {
  location = var.region
  name     = "initdb"
  project  = var.project_id

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "100"
        "run.googleapis.com/vpc-access-connector" = var.google_vpc_connector_selflink
        "run.googleapis.com/vpc-access-egress"    = "private-ranges-only"
      }
    }

    spec {
      container_concurrency = 80
      service_account_name  = data.google_compute_default_service_account.default.email
      timeout_seconds       = 300
      containers {
        image = var.inidb_container_name

        env {
          name  = "MYSQL_HOST"
          value = var.database_private_ip
        }

        env {
          name  = "MYSQL_USER"
          value = var.db_user
        }

        env {
          name  = "MYSQL_PASSWD"
          value = var.db_password
        }

        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "512Mi"
          }
        }
      }
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress"        = "all"
      "run.googleapis.com/ingress-status" = "all"
    }
  }

}
