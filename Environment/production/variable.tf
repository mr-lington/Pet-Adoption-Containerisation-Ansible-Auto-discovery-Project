# variable of vpc cidr_block with a default
variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

# create vpc variable
variable "vpc_id" {
  default = ""
}

variable "pubsub1" {
  default = "10.0.1.0/24"
}

variable "pubsub2" {
  default = "10.0.2.0/24"
}

variable "prvsub1" {
  default = "10.0.3.0/24"
}

variable "prvsub2" {
  default = "10.0.4.0/24"
}

# allow all IP
variable "allow_all_IP" {
  default = "0.0.0.0/0"
}


variable "SSH" {
  default = "22"
}

variable "Jenkins_port" {
  default = "8080"
}

variable "egress_from_and_to" {
  default = "0"
}

variable "egress_protocol" {
  default = "-1"
}

variable "SonarQube_port" {
  default = "9000"
}

# Docker AMI which ubuntun and london eu-west 2 region
variable "AMI-ubuntu" {
  default = "ami-09744628bed84e434"
}

variable "redhat-london" {
  default = "ami-08d9bb4bfe39be5c2"
}

variable "instanceType-t2-micro" {
  default = "t2.micro"
}

variable "instanceType-t2-medium" {
  default = "t2.medium"
}

variable "pub-key" {
  default = ""
}


variable "docker-prod-SG-ID" {
  default = ""
}

variable "docker-stage-SG-ID" {
  default = ""
}

variable "bastion-SG-ID" {
  default = ""
}

variable "tls_private_key" {
  default = ""
}

variable "ansible-SG-ID" {
  default = ""
}


variable "docker-stage-ip" {
  default = ""
}

variable "docker-prod-ip" {
  default = ""
}

variable "jenkins-SG-ID" {
  default = ""
}

variable "sonarqube-SG-ID" {
  default = ""
}

# ALB ingress application traffic for docker
variable "app_port" {
  default = 8080
}

# the server that the load balancer attachment
variable "target_id_docker_stage" {
  default = ""
}

# ALB unsecured listener traffic for docker stage
variable "unsecured_listener_port" {
  default = 80
}

# the server that the load balancer attachment
variable "target_id_docker_prod" {
  default = ""
}

variable "stage-ALB-SG" {
  default = ""
}

variable "prod-ALB-SG" {
  default = ""
}

variable "iam_instance_profile-name" {
  default = ""
}

# DOMAIN NAME
variable "domain_name" {
  default = "greatestshalomventures.com"
}

# docker prod ALB dns name
variable "docker_prod_ALB_dns_name" {
  default = ""
}

# docker prod ALB zone id
variable "docker_prod_ALB_zone_id" {
  default = ""
}

variable "petadopt-signed-cert" {
  default = ""
}

variable "secured_listener_port" {
  default = "443"

}

# ALB secured https traffic/access for docker prod
variable "secured_https" {
  default = 443
}

variable "docker_prod_lb_tg_arn" {
  default = ""
}

variable "iam_instance_profile" {
  default = ""
}