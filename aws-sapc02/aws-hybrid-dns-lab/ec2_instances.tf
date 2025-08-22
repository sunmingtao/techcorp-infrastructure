# Test instance in App VPC A (private subnet)
resource "aws_instance" "test_app_a" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type           = "t3.micro"
  key_name                = var.key_pair_name != "" ? var.key_pair_name : null
  subnet_id               = aws_subnet.app_a_private.id
  vpc_security_group_ids  = [aws_security_group.instance_sg.id]
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    hostname = "test-app-a"
    domain   = var.domain_name
  }))

  tags = {
    Name    = "${var.project_name}-test-app-a"
    Project = var.project_name
  }
}

# Test instance in App VPC B (private subnet)
resource "aws_instance" "test_app_b" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type           = "t3.micro"
  key_name                = var.key_pair_name != "" ? var.key_pair_name : null
  subnet_id               = aws_subnet.app_b_private.id
  vpc_security_group_ids  = [aws_security_group.app_b_instance_sg.id]
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    hostname = "test-app-b"
    domain   = var.domain_name
  }))

  tags = {
    Name    = "${var.project_name}-test-app-b"
    Project = var.project_name
  }
}

# On-premises simulator in public subnet
resource "aws_instance" "onprem_simulator" {
  ami                     = data.aws_ami.amazon_linux.id
  instance_type           = "t3.micro"
  key_name                = var.key_pair_name != "" ? var.key_pair_name : null
  subnet_id               = aws_subnet.app_a_public.id
  vpc_security_group_ids  = [aws_security_group.instance_sg.id]
  
  user_data = base64encode(templatefile("${path.module}/onprem_user_data.sh", {
    hostname           = "onprem-simulator"
    domain            = var.domain_name
  	resolver_ip_1     = tolist(aws_route53_resolver_endpoint.inbound.ip_address)[0].ip
    resolver_ip_2     = tolist(aws_route53_resolver_endpoint.inbound.ip_address)[1].ip

  }))

  tags = {
    Name    = "${var.project_name}-onprem-simulator"
    Project = var.project_name
  }

  depends_on = [aws_route53_resolver_endpoint.inbound]
}
