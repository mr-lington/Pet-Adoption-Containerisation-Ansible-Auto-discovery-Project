# Create  Target Group for docker prod
resource "aws_lb_target_group" "lington_docker_prod_ALB_TG" {
  name     = "lington-docker-prod-ALB-TG"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
    path                = "/"
  }

}

# Create prod Target Group Attachment
resource "aws_lb_target_group_attachment" "lington_docker_prod_alb_attach" {
  target_group_arn = aws_lb_target_group.lington_docker_prod_ALB_TG.arn
  target_id        = var.target_id_docker_prod
  port             = var.app_port
}

#Create prod Load Balancer for prod
resource "aws_lb" "lington_docker_prod_ALB" {
  name               = "lington-docker-prod-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.docker_prod_ALB_SG.id]
  subnets            = [var.pubsub1, var.pubsub2]

  enable_deletion_protection = false


  tags = {
    Environment = "Production"
  }
}

#Create prod Load Balancer Listener
resource "aws_lb_listener" "lington_docker_prod_ALB_listener" {
  load_balancer_arn = aws_lb.lington_docker_prod_ALB.arn
  port              = var.secured_listener_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.petadopt-signed-cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lington_docker_prod_ALB_TG.arn
  }
}

# Inorder to create a ALB for docker prod and docker prod, first we must create a separate security groups and the listener will either be http port 80 or https port 443

# Creating Security group docker prod App load Balancer
resource "aws_security_group" "docker_prod_ALB_SG" {
  name        = "docker_prod_ALB_SG"
  description = "docker prod traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "application traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }

  ingress {
    description = "https access"
    from_port   = var.secured_https
    to_port     = var.secured_https
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
    Name = "docker_prod_ALB_SG"

  }
}