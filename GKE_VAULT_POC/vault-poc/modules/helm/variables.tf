
variable "project_id" {
  type = string
}

variable "unseal_keyring_name" {
  type        = string
  description = "Keyring name containing the GKMS key that will unseal Vault"
}

variable "unseal_key_name" {
  type        = string
  description = "Name of key inside the unseal keyring that unseals the vault"
}

variable "unseal_account_name" {
  type        = string
  description = "Name of Service Account used to unseal vault with GKMS key"
}

variable "storage_bucket_name" {
  type        = string
  description = "Name of Storage Account used for vault"
}


variable "region" {
  type = string
}

variable "kubeconfig" {}
variable "node_pool_id_common" {}