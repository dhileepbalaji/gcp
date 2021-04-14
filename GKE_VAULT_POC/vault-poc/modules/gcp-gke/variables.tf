variable "region" {
  type        = string
  default     = "us-east1"
  description = "Region in which to create the cluster and run Vault."
}

variable "project_id" {
  type        = string
  default     = ""
}

# GKE Kubernetes
variable "kubernetes_version" {
  type        = string
}

variable "gke_cluster_name" {
  type        = string
}

variable "gke_instance_type" {
  type        = string
  default     = "n1-standard-2"
  description = "Instance type to use for the nodes."
}


variable "initial_node_count" {
  type        = number
  default     = 1
  description = "Number of nodes to deploy in each zone of the Kubernetes cluster."
}

variable "gke_daily_maintenance_window" {
  type        = string
  default     = "06:00"
  description = "Maintenance window for GKE."
}

variable "gke_logging_service" {
  type        = string
  default     = "logging.googleapis.com/kubernetes"
  description = "By default this uses the new Stackdriver GKE beta."
}

variable "gke_monitoring_service" {
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
  description = "By default this uses the new Stackdriver GKE beta."
}

variable "kubernetes_secrets_crypto_key" {
  type        = string
  default     = "kubernetes-secrets"
  description = "Name of the KMS key to use for encrypting the Kubernetes database."
}

# vpc

variable "vpc_name" {
  type        = string
}

variable "auto_create_subnetworks" {
  type        = bool
  default     = false
}

variable "vpc_subnet_name" {
  type        = string
}


variable "gke_network_ipv4_cidr" {
  type        = string
  default     = "10.0.12.0/22"
  description = "IP CIDR block for the subnetwork. This must be at least /22 and cannot overlap with any other IP CIDR ranges."
}

variable "gke_pods_ipv4_cidr" {
  type        = string
  default     = "10.0.8.0/22"
  description = "IP CIDR block for pods. This must be at least /22 and cannot overlap with any other IP CIDR ranges."
}

variable "gke_services_ipv4_cidr" {
  type        = string
  default     = "10.0.4.0/22"
  description = "IP CIDR block for k8s services"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#master_ipv4_cidr_block
variable "gke_masters_ipv4_cidr" {
  type        = string
  default     = "10.0.0.0/28"
  description = "IP CIDR block for the Kubernetes master nodes. This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet"
}

variable "gke_master_authorized_networks" {
  type = list(object({
    display_name = string
    cidr_block   = string
  }))

  default = [
    {
      display_name = "Anyone"
      cidr_block   = "0.0.0.0/0"
    },
  ]

  description = "List of CIDR blocks to allow access to the Kubernetes master's API endpoint. This is specified as a slice of objects, where each object has a display_name and cidr_block attribute. The default behavior is to allow anyone (0.0.0.0/0) access to the endpoint. You should restrict access to external IPs that need to access the Kubernetes cluster."
}

variable "vault_service_account" {
  type    = string
}

