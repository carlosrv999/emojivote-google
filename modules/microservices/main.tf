resource "google_container_cluster" "primary" {
  name             = "cluster-emoji"
  location         = var.region
  enable_autopilot = true
  networking_mode  = "VPC_NATIVE"
  network          = var.network
  subnetwork       = var.subnetwork

  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "WORKLOADS",
    ]
  }

  release_channel {
    channel = "REGULAR"
  }

  default_snat_status {
    disabled = false
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.191.0.0/17"
    services_ipv4_cidr_block = "10.191.128.0/21"
  }

}

resource "google_compute_global_address" "default" {
  name         = var.global_address_name
  address_type = "EXTERNAL"
}
