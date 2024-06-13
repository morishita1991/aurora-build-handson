# main.tf

# ---------------------------------------------
# Variables
# ---------------------------------------------
# 変数名：project
# 型：string
variable "project" {
  type = string
}

# 変数名：environment
# 型：string
variable "environment" {
  type = string
}

variable "public_1a_address" {
  type = string
}

variable "public_1c_address" {
  type = string
}
variable "vpc_address" {
  type = string
}

# 変数名：http_port
# 型：number
variable "http_port" {
  type = number
}

# 変数名：https_port
# 型：number
variable "https_port" {
  type = number
}

# 変数名：ssh_port
# 型：number
variable "ssh_port" {
  type = number
}

#variable "key_pair_path" {
#  type = string
#}

#variable "ami_name" {
#  type = string
#}

module "Network" {
  source = "./modules/network"

  // source に渡す引数
  vpc_address = var.vpc_address
  project = var.project
  environment = var.environment
  public_1a_address = var.public_1a_address
  public_1c_address = var.public_1c_address
}
