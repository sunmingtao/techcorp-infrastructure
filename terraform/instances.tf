# Frontend Server (Ubuntu 22.04)
  resource "aws_instance" "tc_frontend" {
    ami                    = "ami-0d016af584f4febe3"  # Ubuntu 22.04 LTS
    instance_type          = "t3.small"
    key_name               = var.key_pair_name
    vpc_security_group_ids = [aws_security_group.frontend_sg.id]
    subnet_id              = aws_subnet.public_subnet.id
   
    tags = {
      Name = "tc-frontend"
      Role = "loadbalancer-web"
    }
  }

  # Backend Server (RHEL 9)
  resource "aws_instance" "tc_backend" {
    ami                    = "ami-05f26a378a37b8fec"  # RHEL 9
    instance_type          = "t3.medium"
    key_name               = var.key_pair_name
    vpc_security_group_ids = [aws_security_group.internal_sg.id]
    subnet_id              = aws_subnet.private_subnet.id

    tags = {
      Name = "tc-backend"
      Role = "database-app"
    }
  }

  # Ops Server (CentOS Stream 9)
  resource "aws_instance" "tc_ops" {
    ami                    = "ami-03e718bac5d2ec021"  # CentOS Stream 9
    instance_type          = "t3.small"
    key_name               = var.key_pair_name
    vpc_security_group_ids = [aws_security_group.internal_sg.id]
    subnet_id              = aws_subnet.private_subnet.id
   
    tags = {
      Name = "tc-ops"
      Role = "monitoring-backup"
    }
  }

  # Additional EBS volumes for storage labs
  resource "aws_ebs_volume" "backend_storage" {
    availability_zone = "${var.aws_region}a"
    size              = 20
    type              = "gp3"

    tags = {
      Name = "tc-backend-storage"
    }
  }

  resource "aws_volume_attachment" "backend_storage_attach" {
    device_name = "/dev/sdf"
    volume_id   = aws_ebs_volume.backend_storage.id
    instance_id = aws_instance.tc_backend.id
  }