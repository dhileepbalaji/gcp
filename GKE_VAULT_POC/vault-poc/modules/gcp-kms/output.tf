output "unseal_keyring_name" {
  value = google_kms_key_ring.vault.name
}

output "unseal_key_name" {
  value = google_kms_crypto_key.vault-init.name
}

output "unseal_key_id" {
  value = google_kms_crypto_key.vault-init.self_link
}

output "service_account" {
  value = google_service_account.vault_kms.email
}

output "keyring_location" {
  value = var.keyring_location
}




