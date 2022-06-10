resource "aws_key_pair" "admin" {
  key_name   = "admin-${local.resource_name}"
  public_key = var.ssh_public_key
}

locals {
  egress_rules = [{
    type             = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = null
  }]
  ipv4_rules = length(var.allowed_cidr_blocks) == 0 ? [] : [{
    type             = "ingress"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = var.allowed_cidr_blocks
    ipv6_cidr_blocks = null
  }]
  ipv6_rules = length(var.allowed_ipv6_cidr_blocks) == 0 ? [] : [{
    type             = "ingress"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = null
    ipv6_cidr_blocks = var.allowed_ipv6_cidr_blocks
  }]

  security_group_rules = concat(local.egress_rules, local.ipv4_rules, local.ipv6_rules)
}

module "bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "~>0.26.0"

  ami_owners = ["099720109477"] // ubuntu
  ami_filter = {
    name                = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    architecture        = ["x86_64"]
    virtualization-type = ["hvm"]
  }

  security_group_rules = local.security_group_rules

  ssh_user                    = "ubuntu"
  key_name                    = aws_key_pair.admin.key_name
  name                        = "bastion-${random_string.resource_suffix.result}"
  subnets                     = local.public_subnet_ids
  vpc_id                      = local.vpc_id
  associate_public_ip_address = true
  assign_eip_address          = false
}

locals {
  security_group_id = module.bastion.security_group_id
  role_name         = module.bastion.role
}
