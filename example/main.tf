module "pki" {
  source = "../"
  hosts  = var.hosts
  domain = "primary.local"
}
