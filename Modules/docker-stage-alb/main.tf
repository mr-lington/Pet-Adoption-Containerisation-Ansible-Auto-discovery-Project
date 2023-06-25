# Create  Target Group for docker stage
resource "aws_lb_target_group" "lington_docker_stage_ALB_TG" {
  name     = "lington-docker-stage-ALB-TG"
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

# Create Stage Target Group Attachment
resource "aws_lb_target_group_attachment" "lington_docker_stage_alb_attach" {
  target_group_arn = aws_lb_target_group.lington_docker_stage_ALB_TG.arn
  target_id        = var.target_id_docker_stage
  port             = var.app_port
}

#Create Stage Load Balancer for stage
resource "aws_lb" "lington_docker_stage_ALB" {
  name               = "lington-docker-stage-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.docker_stage_ALB_SG.id]
  subnets            = [var.pubsub1, var.pubsub2]

  enable_deletion_protection = false


  tags = {
    Environment = "Testing"
  }
}

#Create Stage Load Balancer Listener
resource "aws_lb_listener" "lington_docker_stage_ALB_listener" {
  load_balancer_arn = aws_lb.lington_docker_stage_ALB.arn
  port              = var.unsecured_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lington_docker_stage_ALB_TG.arn
  }
}

# Inorder to create a ALB for docker stage and docker prod, first we must create a separate security groups and the listener will either be http port 80 or https port 443

# Creating Security group docker stage App load Balancer
resource "aws_security_group" "docker_stage_ALB_SG" {
  name        = "docker_stage_ALB_SG"
  description = "docker stage traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "application traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = [var.allow_all_IP]
  }

  ingress {
    description = "listener traffic"
    from_port   = var.unsecured_listener_port
    to_port     = var.unsecured_listener_port
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
    Name = "docker_stage_ALB_SG"
  }
}