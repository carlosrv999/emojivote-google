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
        image = var.initdb_container_name

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

resource "google_cloud_run_service" "emoji_api" {
  location = var.region
  name     = "emojiapi"
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
        image = var.emojiapi_container_name

        env {
          name  = "MYSQL_HOST"
          value = var.database_private_ip
        }

        env {
          name  = "MYSQL_USER"
          value = var.emoji_db_user
        }

        env {
          name  = "MYSQL_PORT"
          value = "3306"
        }

        env {
          name  = "MYSQL_PASSWD"
          value = var.emoji_db_password
        }

        env {
          name  = "MYSQL_DB"
          value = "emoji"
        }

        ports {
          container_port = 3000
          name           = "http1"
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

  traffic {
    latest_revision = true
    percent         = 100
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress"        = "all"
      "run.googleapis.com/ingress-status" = "all"
    }
  }

}

resource "google_cloud_run_service" "vote_api" {
  location = var.region
  name     = "voteapi"
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
        image = var.voteapi_container_name

        env {
          name  = "MYSQL_HOST"
          value = var.database_private_ip
        }

        env {
          name  = "MYSQL_USER"
          value = var.vote_db_user
        }

        env {
          name  = "MYSQL_PORT"
          value = "3306"
        }

        env {
          name  = "MYSQL_PASSWD"
          value = var.vote_db_password
        }

        env {
          name  = "MYSQL_DB"
          value = "votes"
        }

        ports {
          container_port = 3001
          name           = "http1"
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

  traffic {
    latest_revision = true
    percent         = 100
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress"        = "all"
      "run.googleapis.com/ingress-status" = "all"
    }
  }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth_emoji" {
  location = google_cloud_run_service.emoji_api.location
  project  = google_cloud_run_service.emoji_api.project
  service  = google_cloud_run_service.emoji_api.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_service_iam_policy" "noauth_vote" {
  location = google_cloud_run_service.emoji_api.location
  project  = google_cloud_run_service.emoji_api.project
  service  = google_cloud_run_service.vote_api.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
