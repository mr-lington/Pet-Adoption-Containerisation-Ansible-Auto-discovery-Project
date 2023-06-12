resource "aws_instance" "docker_prod_Server" {
  ami                    = var.AMI-ubuntu
  instance_type          = var.instanceType-t2-micro
  key_name               = var.pub-key
  subnet_id              = var.prvsub1
  vpc_security_group_ids = var.docker-prod-SG-ID
  user_data              = local.user_data_docker_prod


  tags = {
    Name = "docker-prod-server"
  }
}

data "aws_instance" "docker_prod_Server" {
  filter {
    name   = "tag:Name"
    values = ["docker-prod-server"]
  }
  depends_on = [aws_instance.docker_prod_Server]
}