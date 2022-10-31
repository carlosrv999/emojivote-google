output "webapp_load_balancer_ip_address" {
  value = google_compute_global_address.public_static.address
}
