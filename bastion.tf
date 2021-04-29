resource "aws_key_pair" "admin" {
  key_name   = "admin-${random_string.resource_suffix.result}"
  public_key = var.ssh_public_key
}

module "bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.26.0"

  ami                         = "ami-0f40c8f97004632f9"
  ssh_user                    = "ubuntu"
  key_name                    = aws_key_pair.admin.key_name
  allowed_cidr_blocks         = var.allowed_cidr_blocks
  namespace                   = data.ns_workspace.this.slashed_name
  name                        = "bastion-${random_string.resource_suffix.result}"
  subnets                     = data.ns_connection.network.outputs.public_subnet_ids
  vpc_id                      = data.ns_connection.network.outputs.vpc_id
  security_groups             = compact([local.db_user_security_group_id])
  associate_public_ip_address = true
  assign_eip_address          = false
}
