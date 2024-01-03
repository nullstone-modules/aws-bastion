variable "ssh_public_key" {
  type        = string
  description = <<EOF
The initial SSH public key to add to the bastion's authorized_keys file.
This parameter is only used at launch time, changing it will have no effect.
To add additional keys, log into the bastion and add them to the authorized_keys file.
EOF
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
