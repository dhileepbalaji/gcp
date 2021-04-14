# Create the storage bucket
resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-${var.name}"
  project       = var.project_id
  force_destroy = true
  storage_class = "MULTI_REGIONAL"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      num_newer_versions = 1
    }
  }

}

# Grant service account access to the storage bucket
resource "google_storage_bucket_iam_member" "iam_member" {
  count  = length(var.storage_bucket_roles)
  bucket = google_storage_bucket.bucket.name
  role   = element(var.storage_bucket_roles, count.index)
  member = "serviceAccount:${var.serviceaccount}"
}
