variable "location" {
  default = "East US"
}

variable "ssh_public_key" {
  description = "Path to your SSH public key"
  type        = string
}
