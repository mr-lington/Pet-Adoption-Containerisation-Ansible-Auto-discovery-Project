# create vpc variable
variable "vpc_id" {
}

# ALB ingress application traffic for docker
variable "app_port" {
}

# the server that the load balancer attachment
variable "target_id_docker_prod" {
}

variable "pubsub2" {
  
}

variable "pubsub1" {
  
}

# ALB secured https traffic/access for docker prod
variable "secured_https" {
}

# allow all IP
variable "allow_all_IP" {
  
}

variable "egress_from_and_to" {
  
}

variable "egress_protocol" {
  
}

# ALB secured listener traffic port for docker prod
variable "secured_listener_port" {
  
}

variable "petadopt-signed-cert" {
}