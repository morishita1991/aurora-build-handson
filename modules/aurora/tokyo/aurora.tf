resource "aws_rds_cluster" "aurora" {
  cluster_identifier        = "secondary-cluster-tokyo-${var.env}"
  global_cluster_identifier = var.global_cluster_id
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  db_subnet_group_name      = var.subnet_group_name
  vpc_security_group_ids = [var.aws_security_group_aurora_sg_id]
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

  # 毎週金曜日 24:00 〜 25:00 (JST) にメンテナンスを実施
  preferred_maintenance_window = "Fri:15:00-Fri:16:00"

  # 削除保護
  deletion_protection = false
}

resource "aws_rds_cluster_instance" "aurora_reader" {
  identifier         = "reader-instance-tokyo-${var.env}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.serverless"
  engine             = "aurora-mysql"
  db_parameter_group_name = aws_db_parameter_group.aurora_instance_parameter_group.name

  # Performance Insights の有効化
  performance_insights_enabled = true
  performance_insights_retention_period = 7  # データ保存期間（7日:無料利用枠, 最大731日）

  # 拡張モニタリング設定
  monitoring_interval  = 30  # 0 以外（1秒, 5秒, 10秒, 15秒, 30秒, 60秒）を指定
  monitoring_role_arn  = var.rds_enhanced_monitoring_role_arn

  # 毎週月曜日 24:00 〜 25:00 (JST) にメンテナンスを実施
  preferred_maintenance_window = "Mon:15:00-Mon:16:00"
}