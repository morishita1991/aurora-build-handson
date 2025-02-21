resource "aws_db_parameter_group" "aurora_instance_parameter_group" {
  name   = "aurora-instance-parameter-group-osaka-${var.env}"
  family = "aurora-mysql8.0"  # 使用する Aurora MySQL のバージョンに合わせる
  description = "Aurora MySQL instance parameter group"

  # TODO: Aurora インスタンスパラメータグループの設定

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"  # Aurora は FILE しかサポートしていない
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = "1"
  }
}