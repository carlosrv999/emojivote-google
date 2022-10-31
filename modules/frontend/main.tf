# Create Cloud Storage buckets
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "static" {
  name                        = "${random_id.bucket_prefix.hex}-bucket-1"
  location                    = var.region
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  force_destroy               = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  provisioner "local-exec" {
    command = "gsutil -m cp -r ${path.cwd}/source/webapp-emojivote-reborn/dist/emojivote/ gs://${self.name}"
  }

}

resource "google_storage_bucket_iam_member" "public_static" {
  bucket = google_storage_bucket.static.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Reserve IP address
resource "google_compute_global_address" "public_static" {
  name = "emojivote-ip"
}

# Create LB backend buckets
resource "google_compute_backend_bucket" "static" {
  name        = "emojivote"
  description = "Emojivote Website"
  bucket_name = google_storage_bucket.static.name
}

resource "google_compute_url_map" "default" {
  name = "emojivote-https-lb"
  //default_service = google_compute_backend_bucket.static.id

  default_url_redirect {
    host_redirect          = "www.carlosrv125.com"
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = true
  }

  host_rule {
    hosts        = ["www.carlosrv125.com", "carlosrv125.com"]
    path_matcher = "mysite"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_bucket.static.id
  }



}

resource "google_compute_url_map" "redirect" {
  name = "ip-load-balancer-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_https_proxy" "default" {
  name    = "emojivote-https-lb-proxy"
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_ssl_certificate.webapp_cert.id
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "emojivote-https-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.public_static.id
}

resource "google_compute_target_http_proxy" "redirect" {
  name    = "ip-load-balancer-target-proxy"
  url_map = google_compute_url_map.redirect.id
}

resource "google_compute_global_forwarding_rule" "redirect" {
  name                  = "ip-load-balancer-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.public_static.id
  ip_protocol           = "TCP"
  port_range            = "80-80"
  target                = google_compute_target_http_proxy.redirect.id
}

resource "google_compute_managed_ssl_certificate" "default" {
  name = "carlosrv125-certificate"

  managed {
    domains = [
      "emoji.carlosrv125.com.",
      "vote.carlosrv125.com.",
      "www.carlosrv125.com."
    ]
  }
}

resource "google_compute_ssl_certificate" "webapp_cert" {
  name_prefix = "www-carlosrv125-com-cert-"
  description = "webapp emojivote cert"
  private_key = file("${path.cwd}/sslcerts/www.carlosrv125.com.key")
  certificate = file("${path.cwd}/sslcerts/www.carlosrv125.com.crt")

  lifecycle {
    create_before_destroy = true
  }
}
