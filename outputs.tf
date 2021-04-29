output "public_ip" {
  value = module.bastion.public_ip
}

output "ssh_user" {
  value = module.bastion.ssh_user
}
