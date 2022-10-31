output "emoji_url" {
  value = google_cloud_run_service.emoji_api.status[0].url
}

output "vote_url" {
  value = google_cloud_run_service.vote_api.status[0].url
}
