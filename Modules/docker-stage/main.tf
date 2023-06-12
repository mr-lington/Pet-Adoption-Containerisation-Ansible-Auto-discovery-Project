resource "aws_instance" "docker_stage_Server" {
  ami                    = var.AMI-ubuntu
  instance_type          = var.instanceType-t2-micro
  key_name               = var.pub-key
  subnet_id              = var.prvsub2
  vpc_security_group_ids = var.docker-stage-SG-ID
  user_data              = local.user_data_docker_stage


  tags = {
    Name = "docker-stage-server"
  }
}

data "aws_instance" "docker_stage_Server" {
  filter {
    name   = "tag:Name"
    values = ["docker-stage-server"]
  }
  depends_on = [aws_instance.docker_stage_Server]
}