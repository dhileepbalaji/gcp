output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  depends_on = [
    google_container_cluster.primary,
  ]
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "node_pool_id_common" {
   value = google_container_node_pool.common.id
}

output "kubeconfig" {
   value = [
      {
         host                   = google_container_cluster.primary.endpoint
         token                  = data.google_client_config.current.access_token
         cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
      }
   ]
}