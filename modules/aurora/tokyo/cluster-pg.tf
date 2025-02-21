resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name   = "aurora-cluster-parameter-group-tokyo-${var.env}"
  family = "aurora-mysql8.0"  # 使用する Aurora MySQL のバージョンに合わせる
  description = "Aurora MySQL cluster parameter group"

  # TODO: Aurora クラスターパラメータグループの設定

  parameter {
    name  = "long_query_time"
    value = "2"  # 2秒以上のクエリをスロークエリとして記録
  }
}