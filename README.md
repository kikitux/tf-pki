# tf-pki

## one site

```
module "pki" {
  source          = "github.com/kikitux/tf-pki"
  hosts           = var.hosts
}
```

## two or more sites

```
# Generate private key for CA
resource "tls_private_key" "private_key_ca" {
  algorithm = "RSA"
}

module "pki-dc1" {
  source          = "github.com/kikitux/tf-pki"
  hosts           = var.hosts1
  private_key_pem = tls_private_key.private_key_ca.private_key_pem
}

module "pki-dc2" {
  source          = "github.com/kikitux/tf-pki"
  hosts           = var.hosts2
  private_key_pem = tls_private_key.private_key_ca.private_key_pem
}
```
