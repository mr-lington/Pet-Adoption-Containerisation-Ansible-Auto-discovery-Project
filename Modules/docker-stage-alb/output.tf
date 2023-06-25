output "docker_stage_ALB_dns_name" {
  value = aws_lb.lington_docker_stage_ALB.dns_name
}

output "docker-stage-ALB-SG" {
  value = aws_security_group.docker_stage_ALB_SG.id
}