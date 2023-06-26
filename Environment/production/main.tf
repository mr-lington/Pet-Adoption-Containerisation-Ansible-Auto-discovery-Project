module "efe-vpc" {
  source   = "../../modules/vpc"
  vpc-cidr = var.vpc-cidr
}

module "efe-subnet" {
  source       = "../../modules/subnet"
  vpc_id       = module.efe-vpc.vpc_id
  pubsub1      = var.pubsub1
  pubsub2      = var.pubsub2
  prvsub1      = var.prvsub1
  prvsub2      = var.prvsub2
  allow_all_IP = var.allow_all_IP
}

module "efe-security-groups" {
  source             = "../../modules/security-groups"
  vpc_id             = module.efe-vpc.vpc_id
  SSH                = var.SSH
  Jenkins_port       = var.Jenkins_port
  SonarQube_port     = var.SonarQube_port
  egress_from_and_to = var.egress_from_and_to
  egress_protocol    = var.egress_protocol
  allow_all_IP       = var.allow_all_IP
  app_port           = var.app_port
  prod-ALB-SG        = module.efe-docker-prod-ALB.docker-prod-ALB-SG
  stage-ALB-SG       = module.efe-docker-stage-ALB.docker-stage-ALB-SG
}

module "efe-keypair" {
  source = "../../modules/keypair"
}

module "efe-docker-stage" {
  source                = "../../modules/docker-stage"
  AMI-ubuntu            = var.AMI-ubuntu
  instanceType-t2-micro = var.instanceType-t2-micro
  pub-key               = module.efe-keypair.out-pub-key
  prvsub2               = module.efe-subnet.prvsub2
  docker-stage-SG-ID    = [module.efe-security-groups.docker-stage-SG-ID]
}

module "efe-docker-prod" {
  source                = "../../modules/docker-prod"
  AMI-ubuntu            = var.AMI-ubuntu
  instanceType-t2-micro = var.instanceType-t2-micro
  pub-key               = module.efe-keypair.out-pub-key
  prvsub1               = module.efe-subnet.prvsub1
  docker-prod-SG-ID     = [module.efe-security-groups.docker-prod-SG-ID]
}

module "efe-bastion-host" {
  source                = "../../modules/bastion-host"
  redhat-london         = var.redhat-london
  instanceType-t2-micro = var.instanceType-t2-micro
  pub-key               = module.efe-keypair.out-pub-key
  pubsub1               = module.efe-subnet.pubsub1
  bastion-SG-ID         = [module.efe-security-groups.bastion-SG-ID]
  tls_private_key       = module.efe-keypair.out-priv-key
}

module "efe-ansible" {
  source                 = "../../modules/ansible"
  AMI-ubuntu             = var.AMI-ubuntu
  instanceType-t2-medium = var.instanceType-t2-medium
  pub-key                = module.efe-keypair.out-pub-key
  pubsub2                = module.efe-subnet.pubsub2
  ansible-SG-ID          = [module.efe-security-groups.ansible-SG-ID]
  tls_private_key        = module.efe-keypair.out-priv-key
  docker-stage-ip        = module.efe-docker-stage.docker-stage-ip
  docker-prod-ip         = module.efe-docker-prod.docker-production-ip

}

module "efe-jenkins" {
  source                 = "../../modules/jenkins"
  redhat-london          = var.redhat-london
  instanceType-t2-medium = var.instanceType-t2-medium
  pub-key                = module.efe-keypair.out-pub-key
  pubsub2                = module.efe-subnet.pubsub2
  jenkins-SG-ID          = [module.efe-security-groups.jenkins-SG-ID]
  tls_private_key        = module.efe-keypair.out-priv-key
}

module "efe-sonarqube" {
  source                 = "../../modules/sonarqube"
  AMI-ubuntu             = var.AMI-ubuntu
  instanceType-t2-medium = var.instanceType-t2-medium
  pub-key                = module.efe-keypair.out-pub-key
  pubsub2                = module.efe-subnet.pubsub2
  sonarqube-SG-ID        = [module.efe-security-groups.sonarqube-SG-ID]
  tls_private_key        = module.efe-keypair.out-priv-key
}

module "efe-docker-stage-ALB" {
  source                  = "../../modules/docker-stage-alb"
  vpc_id                  = module.efe-vpc.vpc_id
  app_port                = var.app_port
  target_id_docker_stage  = module.efe-docker-stage.docker-stage-server-id
  pubsub2                 = module.efe-subnet.pubsub2
  pubsub1                 = module.efe-subnet.pubsub1
  unsecured_listener_port = var.unsecured_listener_port
  egress_from_and_to      = var.egress_from_and_to
  egress_protocol         = var.egress_protocol
  allow_all_IP            = var.allow_all_IP
}

module "efe-docker-prod-ALB" {
  source                = "../../modules/docker-prod-alb"
  vpc_id                = module.efe-vpc.vpc_id
  app_port              = var.app_port
  target_id_docker_prod = module.efe-docker-prod.docker-prod-server-id
  pubsub2               = module.efe-subnet.pubsub2
  pubsub1               = module.efe-subnet.pubsub1
  secured_listener_port = var.secured_listener_port
  secured_https = var.secured_https
  egress_from_and_to    = var.egress_from_and_to
  egress_protocol       = var.egress_protocol
  allow_all_IP          = var.allow_all_IP
   petadopt-signed-cert  = module.efe-route53-ssl.petadopt-signed-cert
}


module "efe-route53-ssl" {
  source                   = "../../modules/route53"
  domain_name              = var.domain_name
  docker_prod_ALB_dns_name = module.efe-docker-prod-ALB.docker_prod_ALB_dns_name
  docker_prod_ALB_zone_id  = module.efe-docker-prod-ALB.docker_prod_ALB_zone_id
}