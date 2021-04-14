variable "serviceaccount" {
  type = string
}

variable "name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "storage_bucket_roles" {
  type = list(string)
  default = [
    "roles/storage.legacyBucketReader",
    "roles/storage.objectAdmin",
  ]
  description = "List of storage bucket roles."
}