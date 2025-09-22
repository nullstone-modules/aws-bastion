output "region" {
  value       = data.aws_region.this.region
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

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "ssh_user" {
  value = "ubuntu"
}
