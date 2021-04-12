# Generate a random ids, GCP projects must have globally unique names
resource "random_id" "project_random" {
  prefix      = var.project_prefix
  byte_length = "8"
}

# Create the project if not specified
resource "google_project" "vault" {
  count           = var.project != "" ? 0 : 1
  name            = random_id.project_random.hex
  project_id      = random_id.project_random.hex
  org_id          = var.org_id
  billing_account = var.billing_account
}

# use an existing project, if var.project defined
data "google_project" "vault" {
  project_id = var.project != "" ? var.project : google_project.vault[0].project_id
}

# vault service account
resource "google_service_account" "vault" {
  account_id   = "vault"
  display_name = "Vault"
  project      = data.google_project.vault.project_id
}

# Add the svc account to the project
resource "google_project_iam_member" "service-account" {
  count   = length(var.service_account_iam_roles)
  project = data.google_project.vault.project_id
  role    = element(var.service_account_iam_roles, count.index)
  member  = "serviceAccount:${google_service_account.vault-server.email}"
}

# Add user-specified roles
resource "google_project_iam_member" "service-account-custom" {
  count   = length(var.service_account_custom_iam_roles)
  project = data.google_project.vault.project_id
  role    = element(var.service_account_custom_iam_roles, count.index)
  member  = "serviceAccount:${google_service_account.vault-server.email}"
}

# Enable required services on the project
resource "google_project_service" "service" {
  count   = length(var.project_services)
  project = data.google_project.vault.project_id
  service = element(var.project_services, count.index)

  # Don't disable the service on destroy. On destroy,we need the APIs available to destroy the
  # underlying resources.
  disable_on_destroy = false
}