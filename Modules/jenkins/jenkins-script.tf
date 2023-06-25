locals {
  jenkins_user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install git -y
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install fontconfig java-11-openjdk
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
cat <<EOT>> /home/ec2-user/.ssh/jenkins_rsa
${var.tls_private_key}
EOT
sudo chmod -R 700 .ssh/
sudo chmod -R ec2-user:ec2-user .ssh/
sudo hostnamectl set-hostname Jenkins
EOF
}