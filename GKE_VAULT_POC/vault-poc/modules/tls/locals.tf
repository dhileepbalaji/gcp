locals {
  full_cert = "${tls_locally_signed_cert.server-cert.cert_pem}\n${tls_self_signed_cert.ca-cert.cert_pem}"
}

resource "local_file" "tls-certificate" {
  filename = "./tls/certificate.cert"
  content  = local.full_cert
}

resource "local_file" "tls-key" {
  filename = "./tls/private.key"
  content  = tls_private_key.server-key.private_key_pem
}

resource "local_file" "ca-tls-certificate" {
  filename = "./tls/ca-certificate.cert"
  content  = tls_self_signed_cert.ca-cert.cert_pem
}

resource "local_file" "ca-tls-key" {
  filename = "./tls/ca-private.key"
  content  = tls_private_key.ca-key.private_key_pem
}