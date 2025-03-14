resource "aws_iam_instance_profile" "this" {
  name = local.resource_name
  role = aws_iam_role.this.name
}

resource "aws_key_pair" "admin" {
  key_name   = "admin-${local.resource_name}"
  public_key = var.ssh_public_key
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = var.instance_type
  subnet_id                   = local.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  disable_api_termination     = false
  monitoring                  = false
  user_data                   = local.cloud_init
  tags                        = merge(local.tags, { Name = local.resource_name })
  associate_public_ip_address = true
  key_name                    = aws_key_pair.admin.key_name
}
