resource "google_sql_database_instance" "master_instance" {
  name             = "terragoat-${var.environment}-master"
  database_version = "POSTGRES_11"
  region           = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "WWW"
        value = "0.0.0.0/0"
      }
    }
    backup_configuration {
      enabled = false
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "terragoat_${var.environment}_dataset"
  access {
    special_group = "allAuthenticatedUsers"
    role          = "READER"
  }
  access {
    role          = "OWNER"
    user_by_email = "dixon@ddalmeida.tech"  # Replace with a valid email
  }
}
# C03xr9eky