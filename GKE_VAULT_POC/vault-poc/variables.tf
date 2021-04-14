variable "region" {
  type        = string
  default     = "us-east1"
  description = "Region in which to create the cluster and run Vault."
}

variable "project_id" {
  type        = string
  default     = "csrtraefik"
  description = "If provided, Terraform will create the GKE and Vault cluster inside this project. If not given, Terraform will generate a new project."
}

variable "project_services" {
  type = list(string)
  default = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
  description = "List of services to enable on the project."
}

