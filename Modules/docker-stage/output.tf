output "docker-stage-ip" {
 value =  aws_instance.docker_stage_Server.private_ip
}

output "docker-stage-server-id" {
 value =  aws_instance.docker_stage_Server.id
}