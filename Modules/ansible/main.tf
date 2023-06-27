resource "aws_instance" "Ansible_Server" {
  ami                    = var.AMI-ubuntu
  instance_type          = var.instanceType-t2-medium
  associate_public_ip_address = true
  key_name               = var.pub-key
  subnet_id              = var.pubsub2
  vpc_security_group_ids = var.ansible-SG-ID
  user_data              = local.ansible_user_data
  iam_instance_profile = var.iam_instance_profile


  tags = {
    Name = "Ansible_Server"
  }
}