variable "region" {
  type = string
}

variable "project_id" {
  type = string
}

variable "kms_key_ring" {
  type = string
  default = ""
}

variable "keyring_location" {
  type    = string
  default = "global"
}

variable "kms_crypto_key" {
  type = string
}


variable "service_account_iam_roles" {
  type = list(string)
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
  description = "List of IAM roles to assign to the service account."
}

variable "service_account_custom_iam_roles" {
  type        = list(string)
  default     = []
  description = "List of arbitrary additional IAM roles to attach to the service account on the Vault nodes."
}
