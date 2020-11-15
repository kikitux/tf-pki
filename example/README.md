#


## use

```
module "pki" {
  source = "../"
  hosts  = var.hosts
  domain = "primary.local"
}
```

## outputs

```
#private_key_pem
output "private_key_pem" {
  value = module.pki-primary.private_key_pem
}

#private_key
output "private_key" {
  value = module.pki-primary.private_key["host"].private_key_pem
}

#cert
output "cert" {
  value = module.pki-primary.cert["host"].cert_pem
}
```

