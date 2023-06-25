output "docker-production-ip" {
 value =  aws_instance.docker_prod_Server.private_ip
}

output "docker-prod-server-id" {
 value =  aws_instance.docker_prod_Server.id
}