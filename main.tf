module "iam" {
  source = "./modules/iam"
}

module "vpc_osaka" {
  source    = "./modules/vpc"
  is_osaka = true
  vpc_cidr  = local.vpc_cidr_osaka
  providers = { aws = aws.osaka }
  subnets = {
    "subnet_a" = { cidr = "10.0.1.0/24", az = "ap-northeast-3a" },
    "subnet_b" = { cidr = "10.0.2.0/24", az = "ap-northeast-3c" }
  }
}

module "vpc_tokyo" {
  source    = "./modules/vpc"
  is_osaka = true
  vpc_cidr  = local.vpc_cidr_tokyo
  providers = { aws = aws.tokyo }
  subnets = {
    "subnet_a" = { cidr = "10.1.1.0/24", az = "ap-northeast-1a" },
    "subnet_b" = { cidr = "10.1.2.0/24", az = "ap-northeast-1c" }
  }
}

module "global_db" {
  # # TODO: 本番環境に作成する場合は count 指定を削除すること。
  # count = local.is_prd ? 0 : 1 # TODO: dev 環境実装時は variables.tf で定義した値を入れる

  source = "./modules/global-db"
  env    = local.env # TODO: dev 環境実装時は variables.tf で定義した値を入れる
}

module "aurora_osaka" {
  # TODO: dev 環境実装時は本番環境に作成しない
  # count = local.is_prd ? 0 : 1 # TODO: dev 環境実装時は variables.tf で定義した値を入れる

  source             = "./modules/database"
  env                = local.env # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  is_prd             = local.is_prd # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  region             = "osaka"
  is_osaka           = true
  vpc_id = module.vpc_osaka.vpc_id
  global_cluster_id  = module.global_db.global_cluster_id
  subnet_group_name  = module.vpc_osaka.subnet_group_name
  providers          = { aws = aws.osaka }

  # マスターユーザーの設定
  master_username = "admin"
  master_password = "myadminpassword"

  # Performance Insights の有効化
  performance_insights_enabled = true
  performance_insights_retention_period = 7  # データ保存期間（7日:無料利用枠, 最大731日）
  # 拡張モニタリングの設定
  monitoring_interval = 30  # 0 以外（1秒, 5秒, 10秒, 15秒, 30秒, 60秒）を指定
  rds_enhanced_monitoring_role_arn = module.iam.aurora_enhanced_monitoring_role_arn
  # メンテナンスウィンドウの設定
  cluster_preferred_maintenance_window = "Thu:15:00-Thu:16:00" # 毎週木曜日 24:00 〜 25:00 (JST)
  writer_preferred_maintenance_window = "Tue:15:00-Tue:16:00"  # 毎週火曜日 24:00 〜 25:00 (JST)
  reader_preferred_maintenance_window = "Wed:15:00-Wed:16:00"  # 毎週水曜日 24:00 〜 25:00 (JST)
}

# TODO: Secondary クラスターは 2 段階 apply で作成するため、1 度目の apply ではコメントアウトする
module "aurora_tokyo" {
  # TODO: dev 環境実装時は本番環境に作成しない
  # count = local.is_prd ? 0 : 1 # TODO: dev 環境実装時は variables.tf で定義した値を入れる

  source             = "./modules/database"
  env                = local.env # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  is_prd             = local.is_prd # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  region             = "tokyo"
  is_osaka           = false
  vpc_id = module.vpc_tokyo.vpc_id
  global_cluster_id  = module.global_db.global_cluster_id
  subnet_group_name  = module.vpc_tokyo.subnet_group_name
  providers          = { aws = aws.tokyo }

  # 東京はマスターユーザー不要
  master_username = ""
  master_password = ""

  # Performance Insights の有効化
  performance_insights_enabled = true
  performance_insights_retention_period = 7  # データ保存期間（7日:無料利用枠, 最大731日）
  # 拡張モニタリングの設定
  monitoring_interval = 30  # 0 以外（1秒, 5秒, 10秒, 15秒, 30秒, 60秒）を指定
  rds_enhanced_monitoring_role_arn = module.iam.aurora_enhanced_monitoring_role_arn
  # メンテナンスウィンドウの設定
  cluster_preferred_maintenance_window = "Fri:15:00-Fri:16:00" # 毎週金曜日 24:00 〜 25:00 (JST)
  writer_preferred_maintenance_window = "" # 東京は Writer 不要
  reader_preferred_maintenance_window = "Mon:15:00-Mon:16:00"  # 毎週月曜日 24:00 〜 25:00 (JST)
}