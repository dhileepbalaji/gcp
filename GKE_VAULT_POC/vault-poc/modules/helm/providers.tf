terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "=1.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=1.13.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.0.0"
    }
  }
}

provider "kubernetes" {
  host                   = var.kubeconfig.0.host
  cluster_ca_certificate = base64decode(var.kubeconfig.0.cluster_ca_certificate)
  token                  = var.kubeconfig.0.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = var.kubeconfig.0.host
    cluster_ca_certificate = base64decode(var.kubeconfig.0.cluster_ca_certificate)
    token                  = var.kubeconfig.0.token
    load_config_file       = false
  }
}

