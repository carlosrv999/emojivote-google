data "google_dns_managed_zone" "default" {
  name = var.name
}

resource "google_dns_record_set" "prueba" {
  name = "prueba.${data.google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.default.name

  rrdatas = ["192.168.64.66"]
}
