locals {
  user-data = <<EOF
#!/usr/bin/env bash

systemctl enable amazon-ssm-agent
systemctl start  amazon-ssm-agent
systemctl status amazon-ssm-agent
EOF
}
