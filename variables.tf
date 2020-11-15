variable private_key_pem {
  type    = string
  default = ""
}

variable "hosts" {
  type = map(string)
  description = "map of hosts"
  default = {
    "localhost" = "127.0.0.1"
  }
}

variable "domain" {
  type        = string
  description = "domain to complete FQDN"
  default = "localdomain"
}
