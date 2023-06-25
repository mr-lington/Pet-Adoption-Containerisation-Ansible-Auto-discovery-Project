# Creating Security group ansible(FrontEnd)
resource "aws_security_group" "ansible_lington_FrontEndSG" {
  name        = "lington Ansible"
  description = "Ansible traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH rule VPC"
    from_port   = var.SSH
    to_port     = var.SSH
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }


  egress {
    from_port   = var.egress_from_and_to
    to_port     = var.egress_from_and_to
    protocol    = var.egress_protocol
    cidr_blocks = [var.allow_all_IP]
  }

  tags = {
    Name = "lington_Ansible"
  }
}

# Creating Security group Jenkin(FrontEnd)
resource "aws_security_group" "Jenkin_lington_FrontEndSG" {
  name        = "lington Jenkin"
  description = "Jenkins traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH rule VPC"
    from_port   = var.SSH
    to_port     = var.SSH
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }

  ingress {
    description = "Jenkins port"
    from_port   = var.Jenkins_port
    to_port     = var.Jenkins_port
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }

  egress {
    from_port   = var.egress_from_and_to
    to_port     = var.egress_from_and_to
    protocol    = var.egress_protocol
    cidr_blocks = [var.allow_all_IP]
  }

  tags = {
    Name = "lington_Jenkin"
  }
}

# Creating Security group bastion(FrontEnd)
resource "aws_security_group" "bastion_lington_FrontEndSG" {
  name        = "lington bastion"
  description = "bastion traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH rule VPC"
    from_port   = var.SSH
    to_port     = var.SSH
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }


  egress {
    from_port   = var.egress_from_and_to
    to_port     = var.egress_from_and_to
    protocol    = var.egress_protocol
    cidr_blocks = [var.allow_all_IP]
  }

  tags = {
    Name = "lington_bastion"
  }
}

# Creating Security group sonarQube(FrontEnd)
resource "aws_security_group" "sonarQube_lington_FrontEndSG" {
  name        = "lington sonarQube"
  description = "sonarqube traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH rule VPC"
    from_port   = var.SSH
    to_port     = var.SSH
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }

  ingress {
    description = "SonarQube rule VPC"
    from_port   = var.SonarQube_port
    to_port     = var.SonarQube_port
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }


  egress {
    from_port   = var.egress_from_and_to
    to_port     = var.egress_from_and_to
    protocol    = var.egress_protocol
    cidr_blocks = [var.allow_all_IP]
  }

  tags = {
    Name = "lington_solarQube"
  }
}

# Creating Security group docker stage(BackEnd)
resource "aws_security_group" "docker_stage_lington_BackEndSG" {
  name        = "lington docker stage"
  description = "docker stage traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH rule VPC"
    from_port       = var.SSH
    to_port         = var.SSH
    protocol        = "tcp"
    security_groups = [aws_security_group.ansible_lington_FrontEndSG.id, aws_security_group.bastion_lington_FrontEndSG.id]
  }

# this line points to docker stage load balancer SG
   ingress {
    description     = "http"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.stage-ALB-SG]
    
  }

  egress {
    from_port   = var.egress_from_and_to
    to_port     = var.egress_from_and_to
    protocol    = var.egress_protocol
    cidr_blocks = [var.allow_all_IP]
  }

  tags = {
    Name = "lington_docker_stage"
  }
}

# Creating Security group docker production(BackEnd)
resource "aws_security_group" "docker_prod_lington_BackEndSG" {
  name        = "lington docker production"
  description = "docker production traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH rule VPC"
    from_port       = var.SSH
    to_port         = var.SSH
    protocol        = "tcp"
    security_groups = [aws_security_group.ansible_lington_FrontEndSG.id, aws_security_group.bastion_lington_FrontEndSG.id]
  }

# this line points to docker production load balancer SG
ingress {
    description     = "http"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.prod-ALB-SG]
}

  egress {
    from_port   = var.egress_from_and_to
    to_port     = var.egress_from_and_to
    protocol    = var.egress_protocol
    cidr_blocks = [var.allow_all_IP]
  }

  tags = {
    Name = "lington_docker_prod"
  }
}

