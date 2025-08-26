# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "web_app_high_cpu" {
  alarm_name          = "${var.environment}-web-app-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.web_app_scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app.name
  }
}

resource "aws_cloudwatch_metric_alarm" "web_app_low_cpu" {
  alarm_name          = "${var.environment}-web-app-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.web_app_scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app.name
  }
}
