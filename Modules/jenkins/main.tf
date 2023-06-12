resource "aws_instance" "Jenkins_Server" {
  ami                    = var.redhat-london
  instance_type          = var.instanceType-t2-medium
  associate_public_ip_address = true
  key_name               = var.pub-key
  subnet_id              = var.pubsub2
  vpc_security_group_ids = var.jenkins-SG-ID
  user_data              = local.jenkins_user_data


  tags = {
    Name = "Jenkins_Server"
  }
}

