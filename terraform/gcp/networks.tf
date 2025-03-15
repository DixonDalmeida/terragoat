resource "google_compute_network" "vpc" {
  name                    = "terragoat-${var.environment}-network"
  description             = "Virtual vulnerable-by-design network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public-subnetwork" {
  name          = "terragoat-${var.environment}-public-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id

  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
   # New secondary range for GKE Services
  secondary_ip_range {
    range_name    = "gke-terragoat-dev-cluster-services-new"
    ip_cidr_range = "10.46.0.0/20"  # Adjust based on available IPs
  }
}

resource "google_compute_firewall" "allow_all" {
  name          = "terragoat-${var.environment}-firewall"
  network       = google_compute_network.vpc.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}
