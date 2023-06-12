resource "aws_instance" "sonarqude_server" {
  ami                    = var.AMI-ubuntu
  instance_type          = var.instanceType-t2-medium
  associate_public_ip_address = true
  key_name               = var.pub-key
  subnet_id              = var.pubsub2
  vpc_security_group_ids = var.sonarqube-SG-ID
  user_data              = local.sonarqube_user_data


  tags = {
    Name = "sonarqube_Server"
  }
}