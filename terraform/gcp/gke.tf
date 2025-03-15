data "google_compute_zones" "available_zones" {
  project = var.project
  region  = var.region
}

resource "google_container_cluster" "workload_cluster" {
  name               = "terragoat-${var.environment}-cluster"
  logging_service    = "none"
  location           = var.region
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  enable_legacy_abac       = true
  monitoring_service       = "none"
  deletion_protection = false
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.public-subnetwork.name
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-terragoat-dev-cluster-services-new"
    services_secondary_range_name = "tf-test-secondary-range-update1"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "0.0.0.0/0"
    }
  }
   node_config {
    # machine_type = "e2-medium"  # Choose an appropriate machine type
    disk_size_gb = 10           # Reduce disk size (Default is usually 100GB)
  }
  lifecycle {
    ignore_changes = [initial_node_count,node_config ]
  }
    networking_mode = "VPC_NATIVE"

}

# resource "google_container_node_pool" "custom_node_pool" {
#   cluster  = google_container_cluster.workload_cluster.name
#   location = var.region

#   node_config {
#     image_type = "Ubuntu"
#     disk_size_gb = 10
#   }
# }
