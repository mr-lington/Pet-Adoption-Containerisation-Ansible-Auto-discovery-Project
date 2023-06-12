#PROVISIONING BASTION HOST(JUMP BOX)
resource "aws_instance" "Bastion_Server" {
  ami                         = var.redhat-london
  instance_type               = var.instanceType-t2-micro
  associate_public_ip_address = true
  key_name                    = var.pub-key
  subnet_id                   = var.pubsub1
  vpc_security_group_ids      = var.bastion-SG-ID
  user_data = local.bastion_user_data



  tags = {
    Name = "Bastion-server"
  }
}