variable private_key_pem {
  type    = string
  default = ""
}

variable "hosts" {
  type = map(string)

  default = {
    "localhost" = "127.0.0.1"
  }
  description = "map of hosts"
}

variable "domain" {
  type        = string
  default     = "localdomain"
  description = "domain to complete FQDN"
}
