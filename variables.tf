variable "ssh_public_key" {
  type        = string
  description = "The SSH Public Key to authorize for access to the bastion box."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<EOF
The IP Ranges for users that are allowed to access this bastion from the internet.
By default, this is empty which allows no IPv4 to access the box.
EOF
}

variable "allowed_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<EOF
The IPv6 IP Ranges for users that are allowed to access this bastion from the internet.
By default, this is empty which allows no IPv6 access to the box.
EOF
}
