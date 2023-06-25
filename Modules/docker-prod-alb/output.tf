output "docker_prod_ALB_dns_name" {
  value = aws_lb.lington_docker_prod_ALB.dns_name
}

output "docker-prod-ALB-SG" {
  value = aws_security_group.docker_prod_ALB_SG.id
}