  
variable "hostname" {
  type = string
  description = "The full hostname that will be used. `vault.example.com`"
}

variable "ip_addresses" {
  type = string
  description = "The full ip_addresses that will be used."
}

variable "certificate_duration" {
  description = "Length in hours for the certificate and authority to be valid. Defaults to 6 months."
  default     = 24 * 30 * 6
}

variable "organization_name" {
  type = string
}

variable "common_name" {
  type = string
}

variable "country" {
  type = string
}