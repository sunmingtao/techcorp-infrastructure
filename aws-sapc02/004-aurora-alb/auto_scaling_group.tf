# Auto Scaling Group
resource "aws_autoscaling_group" "web_app" {
  name                = "${var.environment}-web-app-asg"
  vpc_zone_identifier = aws_subnet.private_app[*].id
  target_group_arns   = [aws_lb_target_group.web_app.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = 2
  max_size         = 6
  desired_capacity = 2

  launch_template {
    id      = aws_launch_template.web_app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-web-app-asg"
    propagate_at_launch = false
  }
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "web_app_scale_up" {
  name                   = "${var.environment}-web-app-scale-up"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.web_app.name
}

resource "aws_autoscaling_policy" "web_app_scale_down" {
  name                   = "${var.environment}-web-app-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown              = 300
  autoscaling_group_name = aws_autoscaling_group.web_app.name
}
