variable "ssh_public_key" {
  type        = string
  description = <<EOF
The initial SSH public key to add to the bastion's authorized_keys file.
This parameter is only used at launch time, changing it will have no effect.
To add additional keys, log into the bastion and add them to the authorized_keys file.
EOF
}

/*
variable "ssh_public_keys" {
  type        = list(string)
  default     = []
  description = <<EOF
A list of additional SSH public keys to add to the bastion's authorized_keys file.
This parameter only affects the instance at launch time.
To change keys, you can recreate the bastion or log into the bastion and add keys to `/home/ubuntu/.ssh/authorized_keys`.
EOF
}
*/

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

variable "instance_type" {
  type        = string
  default     = "t3.nano"
  description = <<EOF
Instance Type that dictates CPU, Memory, network bandwidth, and file storage type and bandwidth.
See https://aws.amazon.com/ec2/instance-types/ for EC2 instance types.
EOF
}
