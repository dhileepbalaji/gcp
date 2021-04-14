# Generate self-signed TLS certificates.
resource "tls_private_key" "ca-key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "ca-cert" {
  key_algorithm   = tls_private_key.ca-key.algorithm
  private_key_pem = tls_private_key.ca-key.private_key_pem

  subject {
    organization = var.organization_name
    common_name  = var.common_name
    country      = var.country
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "digital_signature",
    "key_encipherment",
  ]

}

# Create tls server certificates
resource "tls_private_key" "server-key" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Create request to sign the cert with our CA
resource "tls_cert_request" "server-cert-csr" {
  key_algorithm   = tls_private_key.server-key.algorithm
  private_key_pem = tls_private_key.server-key.private_key_pem

  dns_names = [var.hostname]

  ip_addresses = [var.ip_addresses]

  subject {
    organization = var.organization_name
    common_name  = var.common_name
  }
}

# Sign the tls cert
resource "tls_locally_signed_cert" "server-cert" {
  cert_request_pem = tls_cert_request.server-cert-csr.cert_request_pem

  ca_key_algorithm   = tls_private_key.ca-key.algorithm
  ca_private_key_pem = tls_private_key.ca-key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca-cert.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "cert_signing",
    "client_auth",
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]

}

