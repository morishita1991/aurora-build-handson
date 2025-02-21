terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-3"
  alias  = "osaka"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "tokyo"
}