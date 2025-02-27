resource "aws_rds_cluster" "aurora" {
  cluster_identifier        = "${var.is_osaka ? "primary" : "secondary"}-cluster-${var.region}-${var.env}"
  global_cluster_identifier = var.global_cluster_id
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  db_subnet_group_name      = var.subnet_group_name
  vpc_security_group_ids    = [aws_security_group.aurora_sg.id]
  master_username           = var.master_username
  master_password           = var.master_password
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.name
  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 30
  }
  skip_final_snapshot = true
  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery"
  ]
  preferred_maintenance_window = var.cluster_preferred_maintenance_window
  # 削除保護
  deletion_protection = false
}

resource "aws_rds_cluster_instance" "aurora_writer" {
  # Writer インスタンスは大阪リージョンの場合のみ作成
  count              = var.is_osaka ? 1 : 0

  identifier         = "writer-instance-${var.region}-${var.env}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine             = "aurora-mysql"
  db_parameter_group_name = aws_db_parameter_group.aurora_instance_parameter_group.name

  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  monitoring_interval  = var.monitoring_interval
  monitoring_role_arn  = var.rds_enhanced_monitoring_role_arn
  preferred_maintenance_window = var.writer_preferred_maintenance_window
}

resource "aws_rds_cluster_instance" "aurora_reader" {
  identifier         = "reader-instance-${var.region}-${var.env}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine             = "aurora-mysql"
  db_parameter_group_name = aws_db_parameter_group.aurora_instance_parameter_group.name

  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  monitoring_interval  = var.monitoring_interval
  monitoring_role_arn  = var.rds_enhanced_monitoring_role_arn
  preferred_maintenance_window = var.reader_preferred_maintenance_window
}