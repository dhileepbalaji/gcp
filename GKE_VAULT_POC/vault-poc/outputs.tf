output "root_token_decrypt_command" {
  value = "gsutil cat gs://${module.gcp_storage.storage_bucket_id}/vault-root | gcloud kms decrypt --location ${module.vault_kms.keyring_location} --keyring ${module.vault_kms.unseal_keyring_name} --key ${module.vault_kms.unseal_key_name} --ciphertext-file - --plaintext-file -"
}

output "unseal_token00_decrypt_command" {
  value = "gsutil cat gs://${module.gcp_storage.storage_bucket_id}/vault-recovery-0 | gcloud kms decrypt --location ${module.vault_kms.keyring_location} --keyring ${module.vault_kms.unseal_keyring_name} --key ${module.vault_kms.unseal_key_name} --ciphertext-file - --plaintext-file -"
}

output "unseal_token01_decrypt_command" {
  value = "gsutil cat gs://${module.gcp_storage.storage_bucket_id}/vault-recovery-1 | gcloud kms decrypt --location ${module.vault_kms.keyring_location} --keyring ${module.vault_kms.unseal_keyring_name} --key ${module.vault_kms.unseal_key_name} --ciphertext-file - --plaintext-file -"
}

output "unseal_token02_decrypt_command" {
  value = "gsutil cat gs://${module.gcp_storage.storage_bucket_id}/vault-recovery-2 | gcloud kms decrypt --location ${module.vault_kms.keyring_location} --keyring ${module.vault_kms.unseal_keyring_name} --key ${module.vault_kms.unseal_key_name} --ciphertext-file - --plaintext-file -"
}


