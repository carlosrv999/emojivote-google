resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = var.repo_name
  description   = "example docker repository"
  format        = "DOCKER"
}

resource "docker_registry_image" "emoji_api" {
  name = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/emoji-api:v1.0"

  build {
    context = "${path.cwd}/source/emoji-api"
  }
}

resource "docker_registry_image" "vote_api" {
  name = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/vote-api:v1.1"

  build {
    context = "${path.cwd}/source/vote-api"
  }
}

resource "docker_registry_image" "initdb" {
  name = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/initdb:v1.0"

  build {
    context = "${path.cwd}/source/initdb"
  }
}

resource "docker_registry_image" "vote_bot" {
  name = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.repository_id}/vote-bot:v1.0"

  build {
    context = "${path.cwd}/source/vote-bot"
  }
}
