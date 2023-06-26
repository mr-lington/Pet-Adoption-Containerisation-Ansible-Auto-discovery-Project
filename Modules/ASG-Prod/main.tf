# creating the auto scaling group, 
# first create AMI image from the docker production instance
resource "aws_ami_from_instance" "lington_docker_prod_AMI_image" {
  name                    = "lington-docker-prod-AMI-image"
  source_instance_id      = var.source_instance_id
  snapshot_without_reboot = true

  depends_on = [
    var.source_instance_id
  ]
  tags = {
    Name = "lington_docker_prod_AMI_image"
  }
}

# Create launch configuration
resource "aws_launch_configuration" "lington_docker_prod_lconfig" {
  name_prefix                          = "lington-lt"
  image_id                             = aws_ami_from_instance.lington_docker_prod_AMI_image.id
  instance_type                        = var.instanceType-t2-micro
  key_name                             = var.pub-key
  associate_public_ip_address          = false
  security_groups                      = var.docker-prod-SG-ID
  # user_data                            = local.user_data_ASG
  
  
  # /* monitoring {
  #   enabled = true
  # } */
 
  lifecycle {
    create_before_destroy = false
  }
}

# Creating Auto Scaling Group
resource "aws_autoscaling_group" "lington_docker_prod_ASG" {
  name                      = "lington-docker-prod-ASG"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 240
  health_check_type         = "EC2"
  desired_capacity          = 3
  force_delete              = true
  vpc_zone_identifier       = [var.prvsub1, var.prvsub2]
  target_group_arns         = [var.docker_prod_lb_tg_arn]
  launch_configuration      = aws_launch_configuration.lington_docker_prod_lconfig.id

  tag {
    key                 = "Name"
    value               = "docker-prod-ASG"
    propagate_at_launch = true
  }
}

# Creating ASG Policy
resource "aws_autoscaling_policy" "lington-ASG-Policy" {
  autoscaling_group_name = aws_autoscaling_group.lington_docker_prod_ASG.name
  name                   = "lington-docker-prod-ASG-policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}