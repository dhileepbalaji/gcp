# Enable required services on the project
resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = var.project_id
  service = element(var.project_services, count.index)

  # Don't disable the service on destroy. On destroy,we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}

module "k8s_public_ipaddress" {
  source     = "./modules/gcp-external-ip"
  name       = "k8s-vault-external-lb"
  project_id = var.project_id
  region     = var.region
  depends_on = [google_project_service.service,
  ]
}

module "vault_kms" {
  source           = "./modules/gcp-kms"
  project_id       = var.project_id
  region           = "global"
  kms_crypto_key   = "vault_unseal_key"
  depends_on = [google_project_service.service,
  ]
}

module "gcp_storage" {
  source           = "./modules/gcp-storage"
  project_id       = var.project_id
  name             = "vault-poc-7686"
  serviceaccount   = module.vault_kms.service_account
  depends_on = [google_project_service.service,
  ]
}

module "gke-cluster" {
  source                 = "./modules/gcp-gke/"
  region                 = var.region
  project_id             = var.project_id
  kubernetes_version     = "1.18.16-gke.302"
  gke_cluster_name       = "vault-poc-1"
  vpc_name               = "vault-poc-1"
  vpc_subnet_name        = "vault-poc-subnet-1"
  initial_node_count     = "1"
  vault_service_account = module.vault_kms.service_account
  depends_on = [google_project_service.service,
  ]
}

module "vault" {
  source                    = "./modules/helm/"
  project_id                = var.project_id
  region                    = var.region
  kubeconfig                = module.gke-cluster.kubeconfig
  storage_bucket_name       = module.gcp_storage.storage_bucket_id
  unseal_keyring_name       = module.vault_kms.unseal_keyring_name
  unseal_key_name           = module.vault_kms.unseal_key_name
  unseal_account_name       = module.vault_kms.service_account
  node_pool_id_common       = module.gke-cluster.node_pool_id_common
  
}


