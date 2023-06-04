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
}

module "efe-keypair" {
  source = "../../modules/keypair"
}