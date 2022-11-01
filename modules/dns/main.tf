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

resource "google_dns_record_set" "webapp" {
  name = "www.${data.google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.default.name

  rrdatas = [var.webapp_load_balancer_ip_address]
}

resource "google_dns_record_set" "emoji" {
  name = "emoji.${data.google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.default.name

  rrdatas = [var.ingress_ip_address]
}

resource "google_dns_record_set" "vote" {
  name = "api.${data.google_dns_managed_zone.default.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.default.name

  rrdatas = [var.ingress_ip_address]
}
