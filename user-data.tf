locals {
  user_data = {
    users = [
      {
        name                = "ubuntu"
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        shell               = "/bin/bash"
        ssh-authorized-keys = coalesce(var.ssh_public_keys, [])
      }
    ]
    runcmd = [
      "systemctl enable amazon-ssm-agent",
      "systemctl start  amazon-ssm-agent",
      "systemctl status amazon-ssm-agent",
    ]
  }

  cloud_init = <<EOF
#cloud-config
yamlencode(local.user_data)
EOF
}
