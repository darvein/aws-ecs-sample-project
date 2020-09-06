locals {
  db_port           = 5432
  db_storage        = 5
  db_instance_class = "db.t2.large"

  db_user     = "appdbuser"
  db_password = "wiwe1boop0aiGhah"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "${var.project_name}-db"

  engine            = "postgres"
  engine_version    = "9.6.11"
  instance_class    = local.db_instance_class
  allocated_storage = local.db_storage
  storage_encrypted = false

  name     = var.project_name
  username = local.db_user
  password = local.db_password

  port = local.db_port

  vpc_security_group_ids = [local.security_group_id]

  maintenance_window = local.maintenance_window
  backup_window      = local.backup_window

  # disable backups to create DB faster
  backup_retention_period = 0

  #enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.private.ids

  family                    = "postgres9.6"
  major_engine_version      = "9.6"
  final_snapshot_identifier = "${var.project_name}db-snapshot"

  # Database Deletion Protection
  deletion_protection = false

  tags = {
    Cluster     = var.project_name
    Environment = var.environment
  }
}
