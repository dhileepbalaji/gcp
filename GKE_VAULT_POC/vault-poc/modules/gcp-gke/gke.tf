# Like projects, key rings names must be globally unique within the project.
resource "random_id" "kms_random" {
  prefix      = "kubernetes-secrets"
  byte_length = "8"
}

# Obtain the key ring ID or use a randomly generated on.
locals {
  kms_key_ring = random_id.kms_random.hex
}

# Create the KMS key ring
resource "google_kms_key_ring" "kubernetes-secrets" {
  name     = local.kms_key_ring
  location = var.region
  project  = var.project_id

}

# Create the crypto key for encrypting Kubernetes secrets
resource "google_kms_crypto_key" "kubernetes-secrets" {
  name            = var.kubernetes_secrets_crypto_key
  key_ring        = google_kms_key_ring.kubernetes-secrets.id
  rotation_period = "604800s"
}

# Grant GKE access to the key
resource "google_kms_crypto_key_iam_member" "kubernetes-secrets-gke" {
  crypto_key_id = google_kms_crypto_key.kubernetes-secrets.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

# Create the GKE clusters

resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  project  = data.google_project.project.project_id
  location = var.region
  min_master_version = var.kubernetes_version
  node_version = var.kubernetes_version
  default_max_pods_per_node = 30
  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.vpc-subnet.self_link

  initial_node_count = var.initial_node_count
  remove_default_node_pool = true

  logging_service    = var.gke_logging_service
  monitoring_service = var.gke_monitoring_service

  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.kubernetes-secrets.self_link
  }

  node_config {
    machine_type    = var.gke_instance_type
    # Set metadata on the VM to supply more entropy.
    # https://gkesecurity.guide/cluster_lifecycle/
    metadata = {
      # Explicitly remove GCE legacy metadata API endpoint
      disable-legacy-endpoints         = "true"
    }

  }

   # Disable basic authentication and cert-based authentication.
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Enable network policy configurations (like Calico) - Must be configured with
  # the block in the addons section.
  network_policy {
    enabled = false
  }

 # Configure various addons
  addons_config {
    # Enable network policy configurations (like Calico).
    network_policy_config {
      disabled = true
    }
  }

  # Set the maintenance window.
  maintenance_policy {
    daily_maintenance_window {
      start_time = var.gke_daily_maintenance_window
    }
  }

  # Allocate IPs in our subnetwork
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.vpc-subnet.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.vpc-subnet.secondary_ip_range[1].range_name
  }

  # Specify the list of CIDRs which can access the master's API
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.gke_master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  # Configure the cluster to be private (not have public facing IPs)

  private_cluster_config {
    enable_private_nodes   = true
    enable_private_endpoint   = false
    master_ipv4_cidr_block = var.gke_masters_ipv4_cidr
  }

  depends_on = [
    google_compute_router_nat.nat,
  ]
}


