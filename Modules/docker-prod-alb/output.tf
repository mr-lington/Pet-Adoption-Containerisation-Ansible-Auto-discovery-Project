output "docker_prod_ALB_dns_name" {
  value = aws_lb.lington_docker_prod_ALB.dns_name
}

output "docker-prod-ALB-SG" {
  value = aws_security_group.docker_prod_ALB_SG.id
}

output "docker_prod_ALB_zone_id" {
  value = aws_lb.lington_docker_prod_ALB.zone_id
}

output "docker_prod_lb_tg_arn" {
  value = aws_lb_target_group.lington_docker_prod_ALB_TG.arn
}
