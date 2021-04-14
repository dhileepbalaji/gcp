resource "google_container_node_pool" "common" {
  project            = data.google_project.project.project_id
  name               = "common"
  location           = var.region
  cluster            = google_container_cluster.primary.name
  initial_node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  node_config {
    machine_type = "n1-standard-2"
    labels = {
      environment = "common"
    }
    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }

  timeouts {
    create = "30m"
    update = "20m"
  }
  depends_on = [
    google_compute_router_nat.nat,google_kms_crypto_key_iam_member.kubernetes-secrets-gke
  ]
}

