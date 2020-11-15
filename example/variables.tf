variable "hosts" {
  type = map(string)

  default = {
    "host" = "127.0.0.1"
  }
  description = "map of hosts"
}

variable "domain" {
  type        = string
  default     = "local"
  description = "domain to complete FQDN"
}
