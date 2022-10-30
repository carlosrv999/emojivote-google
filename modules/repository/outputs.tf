output "emoji_api" {
  value = docker_registry_image.emoji_api.name
}

output "vote_api" {
  value = docker_registry_image.vote_api.name
}

output "vote_bot" {
  value = docker_registry_image.vote_bot.name
}
