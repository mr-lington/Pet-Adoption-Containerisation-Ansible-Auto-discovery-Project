output "ansible-SG-ID" {
  value = aws_security_group.ansible_lington_FrontEndSG.id
}

output "docker-stage-SG-ID" {
  value = aws_security_group.docker_stage_lington_BackEndSG.id
}

output "docker-prod-SG-ID" {
  value = aws_security_group.docker_prod_lington_BackEndSG.id
}

output "bastion-SG-ID" {
  value = aws_security_group.bastion_lington_FrontEndSG.id
}

output "jenkins-SG-ID" {
  value = aws_security_group.Jenkin_lington_FrontEndSG.id
}

output "sonarqube-SG-ID" {
  value = aws_security_group.sonarQube_lington_FrontEndSG.id
}