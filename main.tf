module "global_db" {
  # # TODO: 本番環境に作成する場合は count 指定を削除すること。
  # count = local.is_prd ? 0 : 1 # TODO: dev 環境実装時は variables.tf で定義した値を入れる

  source = "./modules/global-db"
  env    = local.env # TODO: dev 環境実装時は variables.tf で定義した値を入れる
}

module "iam" {
  source = "./modules/iam"
}

module "sg_osaka" {
  source = "./modules/sg"
  is_osaka = true
  vpc_id = module.vpc_osaka.vpc_id
  providers = { aws = aws.osaka }
}

module "sg_tokyo" {
  source = "./modules/sg"
  is_osaka = false
  vpc_id = module.vpc_tokyo.vpc_id
  providers = { aws = aws.tokyo }
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

module "aurora_osaka" {
  # # TODO: dev 環境実装時は本番環境に作成しない
  # count = local.is_prd ? 0 : 1 # TODO: dev 環境実装時は variables.tf で定義した値を入れる

  source             = "./modules/aurora/osaka"
  env                = local.env # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  is_prd             = local.is_prd # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  global_cluster_id  = module.global_db.global_cluster_id
  subnet_group_name  = module.vpc_osaka.subnet_group_name
  aws_security_group_aurora_sg_id = module.sg_osaka.aws_security_group_aurora_sg_id
  master_username = "admin"
  master_password = "myadminpassword"
  providers          = { aws = aws.osaka }
  rds_enhanced_monitoring_role_arn = module.iam.aurora_enhanced_monitoring_role_arn
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

module "aurora_tokyo" {
  # # TODO: 本番環境に作成する場合は count 指定を削除すること。
  # count = local.is_prd ? 0 : 1 # TODO: dev 環境実装時は variables.tf で定義した値を入れる

  source             = "./modules/aurora/tokyo"
  env                = local.env # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  is_prd             = local.is_prd # TODO: dev 環境実装時は variables.tf で定義した値を入れる
  global_cluster_id  = module.global_db.global_cluster_id
  subnet_group_name  = module.vpc_tokyo.subnet_group_name
    aws_security_group_aurora_sg_id = module.sg_tokyo.aws_security_group_aurora_sg_id
  providers          = { aws = aws.tokyo }
  depends_on = [module.aurora_osaka]
  rds_enhanced_monitoring_role_arn = module.iam.aurora_enhanced_monitoring_role_arn
}