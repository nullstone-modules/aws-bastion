variable "ssh_public_key" {
  type        = string
  description = "The SSH Public Key to authorize for access to the bastion box."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<EOF
The IP Ranges for users that are allowed to access this bastion from the internet.
By default, this is empty which allows nobody to access the box.
EOF
}

resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}
