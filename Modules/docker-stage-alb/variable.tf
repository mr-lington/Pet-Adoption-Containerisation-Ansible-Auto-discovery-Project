# create vpc variable
variable "vpc_id" {
}

# ALB ingress application traffic for docker
variable "app_port" {
}

# the server that the load balancer attachment
variable "target_id_docker_stage" {
}

variable "pubsub2" {
  
}

variable "pubsub1" {
  
}

# ALB unsecured listener traffic for docker stage
variable "unsecured_listener_port" {
}

# allow all IP
variable "allow_all_IP" {
  
}

variable "egress_from_and_to" {
  
}

variable "egress_protocol" {
  
}