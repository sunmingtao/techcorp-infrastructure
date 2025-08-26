# Aurora Subnet Group
resource "aws_db_subnet_group" "aurora" {
  name       = "${var.environment}-aurora-subnet-group"
  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name = "${var.environment}-aurora-subnet-group"
  }
}

# Aurora PostgreSQL Cluster
resource "aws_rds_cluster" "aurora_postgresql" {
  cluster_identifier     = "${var.environment}-aurora-cluster"
  engine                 = "aurora-postgresql"
  engine_version         = "15.4"
  database_name          = "webapp"
  master_username        = var.db_username
  master_password        = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [aws_security_group.aurora.id]
  
  backup_retention_period = 7
  preferred_backup_window = "03:00-04:00"
  
  skip_final_snapshot = true
  deletion_protection = false

  # Enable Auto Scaling
  tags = {
    Name = "${var.environment}-aurora-cluster"
  }
}

# Aurora Writer Instance
resource "aws_rds_cluster_instance" "aurora_writer" {
  identifier         = "${var.environment}-aurora-writer"
  cluster_identifier = aws_rds_cluster.aurora_postgresql.id
  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.aurora_postgresql.engine
  engine_version     = aws_rds_cluster.aurora_postgresql.engine_version

  performance_insights_enabled = true

  tags = {
    Name = "${var.environment}-aurora-writer"
    Role = "Writer"
  }
}

# Aurora Reader Instances (Replicas)
resource "aws_rds_cluster_instance" "aurora_reader" {
  count = 2

  identifier         = "${var.environment}-aurora-reader-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora_postgresql.id
  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.aurora_postgresql.engine
  engine_version     = aws_rds_cluster.aurora_postgresql.engine_version

  performance_insights_enabled = true

  depends_on = [aws_rds_cluster_instance.aurora_writer]

  tags = {
    Name = "${var.environment}-aurora-reader-${count.index + 1}"
    Role = "Reader"
  }
}

# Aurora Auto Scaling for Read Replicas
resource "aws_appautoscaling_target" "aurora_read_replica" {
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.aurora_postgresql.cluster_identifier}"
  min_capacity       = 1
  max_capacity       = 5
}

resource "aws_appautoscaling_policy" "aurora_read_replica_policy" {
  name               = "${var.environment}-aurora-read-replica-scaling"
  service_namespace  = aws_appautoscaling_target.aurora_read_replica.service_namespace
  scalable_dimension = aws_appautoscaling_target.aurora_read_replica.scalable_dimension
  resource_id        = aws_appautoscaling_target.aurora_read_replica.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }
  }
}
