# # out the vpc ID here that we will always be called by other modules
# output "vpc_id" {
#   value = module.efe-vpc.vpc_id
# }

output "docker-stage-ip" {
  value = module.efe-docker-stage.docker-stage-ip
}

output "docker-production-ip" {
  value = module.efe-docker-prod.docker-production-ip
}

output "jenkins-ip" {
  value = module.efe-jenkins.jenkins-ip
}

output "sonarqude-ip" {
  value = module.efe-sonarqube.sonarqude-ip
}

output "ansible-ip" {
  value = module.efe-ansible.ansible-ip
}

output "bastion-ip" {
  value = module.efe-bastion-host.bastion-ip
}

output "stage-load-balancer-dns" {
  value = module.efe-docker-stage-ALB.docker_stage_ALB_dns_name
}

output "prod-load-balancer-dns" {
  value = module.efe-docker-prod-ALB.docker_prod_ALB_dns_name
}