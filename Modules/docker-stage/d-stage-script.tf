locals {
  user_data_docker_stage = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install docker.io -y
  sudo hostnamectl set-hostname Docker-stage
  sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'
  EOF
}


# sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config  ====== dont ask for approval when trying to ssh into the docker