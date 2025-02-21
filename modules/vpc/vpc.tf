resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.is_osaka ? "vpc-osaka" : "vpc-tokyo"
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets
  vpc_id          = aws_vpc.main.id
  cidr_block      = each.value.cidr
  availability_zone = each.value.az
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = var.is_osaka ? "aurora-subnet-group-osaka" : "aurora-subnet-group-tokyo"
  subnet_ids = [for s in aws_subnet.subnets : s.id]
}
