# Generate private key for CA
resource "tls_private_key" "private_key_ca" {
  algorithm = "RSA"
}

# Self-signing the CA 
resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "RSA" # Using RSA
  private_key_pem = var.private_key_pem == "" ? tls_private_key.private_key_ca.private_key_pem : var.private_key_pem
  subject {
    common_name  = "CA" # Modern browsers do not look at the CN, SANs are imporatant
    organization = "CA"
  }
  validity_period_hours = 3600 # Validity in hours
  allowed_uses = [             # Needed permissions for signing server certs.
    "crl_signing",
    "cert_signing"
  ]
  is_ca_certificate = true # It is CA
}

# CA cert
output ca {
  value = tls_self_signed_cert.ca.cert_pem
}

#### GENERATING KEYS FOR SERVERS
# Generating private key for all servers mentioned in var.hosts 
resource "tls_private_key" "private_key" {
  for_each  = var.hosts
  algorithm = "RSA"
}

resource "tls_cert_request" "csr" {
  for_each        = var.hosts
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.private_key[each.key].private_key_pem
  subject {
    common_name  = "${each.key}.${var.domain}" # Just a name, the real names and adresses are in SANs
    organization = "Cluster"
  }
  ip_addresses = [
    "127.0.0.1",
    "127.0.0.1" != each.value ? each.value : "",
  ]
  dns_names = [
    "${each.key}.${var.domain}",
    "localhost"
  ]
}

# Singing each of the generated certs with the CA
resource "tls_locally_signed_cert" "cert_sign" {
  for_each              = var.hosts
  cert_request_pem      = tls_cert_request.csr[each.key].cert_request_pem # Provide the CSR
  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = var.private_key_pem == "" ? tls_private_key.private_key_ca.private_key_pem : var.private_key_pem # CA private key
  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem                                                                 # CA cert
  validity_period_hours = 3600
  # Important, what the cert can be used for
  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "key_agreement"
  ]
  is_ca_certificate = false # It is not CA
}

output private_key_pem {
  value = var.private_key_pem == "" ? tls_private_key.private_key_ca.private_key_pem : var.private_key_pem
}

output private_key {
  value = tls_private_key.private_key #.private_key_pem
}

output cert {
  value = tls_locally_signed_cert.cert_sign #.*.cert_pem
}

