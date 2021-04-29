resource "aws_key_pair" "admin" {
  key_name   = "admin-${random_string.resource_suffix.result}"
  public_key = var.ssh_public_key
}

locals {
  security_group_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = var.allowed_cidr_blocks
    }
  ]
}

module "bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.26.0"

  ami_owners = ["099720109477"] // ubuntu
  ami_filter = {
    name                = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    architecture        = ["x86_64"]
    virtualization-type = ["hvm"]
  }

  security_group_rules = [local.security_group_rules]

  ssh_user                    = "ubuntu"
  key_name                    = aws_key_pair.admin.key_name
  namespace                   = data.ns_workspace.this.slashed_name
  name                        = "bastion-${random_string.resource_suffix.result}"
  subnets                     = data.ns_connection.network.outputs.public_subnet_ids
  vpc_id                      = data.ns_connection.network.outputs.vpc_id
  security_groups             = compact([local.db_user_security_group_id])
  associate_public_ip_address = true
  assign_eip_address          = false
}
