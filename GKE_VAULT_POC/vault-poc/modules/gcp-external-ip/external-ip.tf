resource "google_compute_address" "ext_ip_address" {
  name    = var.name
  project = var.project_id
  region  = var.region
}