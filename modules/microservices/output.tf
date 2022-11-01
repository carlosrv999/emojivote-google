output "ingress_ip_address" {
  value = google_compute_global_address.default.address
}

output "global_address_name" {
  value = google_compute_global_address.default.name
}
