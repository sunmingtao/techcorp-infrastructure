# Launch Template for Web Servers
resource "aws_launch_template" "web_app" {
  name_prefix   = "${var.environment}-web-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_app.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_endpoint = aws_rds_cluster.aurora_postgresql.endpoint
    db_name     = aws_rds_cluster.aurora_postgresql.database_name
    db_username = var.db_username
    db_password = var.db_password
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-web-app"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
