resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_address
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}


// サブネット1a
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_1a_address
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

// サブネット1c
resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_1c_address
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id # Route Tableを配置するVPCを指定

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
