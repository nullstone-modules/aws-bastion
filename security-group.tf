resource "aws_security_group" "this" {
  name   = local.resource_name
  vpc_id = local.vpc_id
  tags   = merge(local.tags, { Name = local.resource_name })

  lifecycle {
    create_before_destroy = true
  }
}

// Package managers rely on external sites; it's inevitable that one of them is reachable on port 80 before transferring to port 443
// This rule ensures that users can install packages
resource "aws_security_group_rule" "this-http-to-world" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "this-http-to-world6" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  ipv6_cidr_blocks  = ["::/0"]
}

// See https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-prerequisites.html
// In order for SSM to work properly, HTTPS (443) oubound must be allowed for
//   - ec2messages.<region>.amazonaws.com
//   - ssm.<region>.amazonaws.com
//   - ssmmessages.<region>.amazonaws.com
resource "aws_security_group_rule" "this-https-to-world" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "this-https-to-world6" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "world-ssh-to-this" {
  for_each = toset(var.allowed_cidr_blocks)

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [each.value]
  ipv6_cidr_blocks  = null
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "world-ipv6-ssh-to-this" {
  for_each = toset(var.allowed_ipv6_cidr_blocks)

  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  ipv6_cidr_blocks  = [each.key]
  security_group_id = aws_security_group.this.id
}
