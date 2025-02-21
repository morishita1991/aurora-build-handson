resource "aws_rds_global_cluster" "global_db" {
  global_cluster_identifier = "global-db-${var.env}"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
}