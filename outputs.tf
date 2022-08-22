output "region" {
  value       = data.aws_region.this.name
  description = "string ||| The AWS region where the EC2 instance resides."
}

output "instance_id" {
  value       = aws_instance.this.id
  description = "string ||| The Instance ID of the EC2 instance."
}

output "adminer" {
  value = {
    name       = aws_iam_user.adminer.name
    access_key = aws_iam_access_key.adminer.id
    secret_key = aws_iam_access_key.adminer.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to admin the EC2 instance."
  sensitive   = true
}

locals {
  // Private and public URLs are shown in the Nullstone UI
  // Typically, they are created through capabilities attached to the application
  // If this module has URLs, add them here as list(string)
  additional_private_urls = []
  additional_public_urls  = ["ssh://ubuntu@${aws_instance.this.public_ip}"]
}

output "private_urls" {
  value       = concat([for url in try(local.capabilities.private_urls, []) : url["url"]], local.additional_private_urls)
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = concat([for url in try(local.capabilities.public_urls, []) : url["url"]], local.additional_public_urls)
  description = "list(string) ||| A list of URLs accessible to the public"
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "ssh_user" {
  value = "ubuntu"
}
