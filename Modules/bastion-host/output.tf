
output "bastion-ip" {
  value = aws_instance.Bastion_Server.public_ip
}