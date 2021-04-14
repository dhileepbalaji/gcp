  
resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
  depends_on = [var.node_pool_id_common,var.kubeconfig]
}

data "google_service_account" "vault-kms" {
  account_id = var.unseal_account_name
}

resource "google_service_account_key" "vault-key" {
  service_account_id = data.google_service_account.vault-kms.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "gcp-vault-sa"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }
  data = {
    "service-account.json" = base64decode(google_service_account_key.vault-key.private_key)
  }
}

resource "helm_release" "vault" {
  name      = "vault"
  chart     = "${path.module}/vault-chart"
  namespace = kubernetes_namespace.vault.metadata.0.name

  values = [
    file("${path.module}/vault-chart/values.yaml")
  ]

  set {
    name  = "vault.key_ring"
    value =  var.unseal_keyring_name
  }
  set {
    name  = "vault.crypto_key"
    value =  var.unseal_key_name
  }
  set {
    name  = "vault.region"
    value = "global"
  }
  set {
    name  = "vault.project"
    value =  var.project_id
  }
  set {
    name  = "vault.bucket"
    value =  var.storage_bucket_name
  }
  set {
    name  = "vault.gcpsasecretname"
    value = "gcp-vault-sa"
  }
  depends_on = [var.node_pool_id_common,var.kubeconfig]
}