variable private_key_pem {
  type    = string
  default = ""
}

variable "hosts" {
  type = map(string)
  description = "map of hosts"
}

variable "domain" {
  type        = string
  description = "domain to complete FQDN"
}
