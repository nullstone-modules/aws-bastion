resource "aws_iam_instance_profile" "this" {
  name = local.resource_name
  role = aws_iam_role.this.name
}

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

resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t3.nano"
  subnet_id                   = local.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  disable_api_termination     = false
  monitoring                  = false
  user_data                   = local.user-data
  tags                        = merge(local.tags, { Name = local.resource_name })
  associate_public_ip_address = true
  security_group_rules        = local.security_group_rules
  key_name                    = aws_key_pair.admin.key_name
  assign_eip_address          = false

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
}
