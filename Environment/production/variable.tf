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
