locals {
  bastion_user_data = <<-EOF
#!/bin/bash
echo "${var.tls_private_key}" > /home/ec2-user/lington_Key
chmod 400 lington_Key
sudo hostnamectl set-hostname Bastion
EOF
}