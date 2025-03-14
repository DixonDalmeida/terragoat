data "google_compute_zones" "zones" {}

resource "google_compute_instance" "server" {
  machine_type = "e2-micro"
  name         = "terragoat-${var.environment}-machine"
  zone         = data.google_compute_zones.zones.names[0]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
    auto_delete = true
  }
  network_interface {
    subnetwork = google_compute_subnetwork.public-subnetwork.name
    access_config {}
  }
  can_ip_forward = true

  metadata = {
    block-project-ssh-keys = false
    enable-oslogin         = false
    serial-port-enable     = true
  }
}

resource "google_compute_disk" "unencrypted_disk" {
  name = "terragoat-${var.environment}-disk"
  size = 10 
 zone = data.google_compute_zones.zones.names[0]
}