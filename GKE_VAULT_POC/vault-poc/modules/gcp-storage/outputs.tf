output "storage_bucket_id" {
  value = google_storage_bucket.bucket.id
}

output "gcs_account_access" {
  value = var.serviceaccount
}