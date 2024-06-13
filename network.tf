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

// ロードバランサー
resource "aws_lb" "sample_alb" {
  name               = "sample-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.opmng_sg.id]

  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]

  ip_address_type = "ipv4"

  tags = {
    Name = "sample-alb"
  }
}

// ターゲットグループ
resource "aws_lb_target_group" "sample_target_group" {
  name             = "sample-target-group"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = 80
  protocol         = "HTTP"

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sample-target-group"
  }

  health_check {
    interval            = 10
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 4
    unhealthy_threshold = 2
    matcher             = "200,301"
  }
}

resource "aws_lb_target_group_attachment" "sample_target_ec2" {
  target_group_arn = aws_lb_target_group.sample_target_group.arn
  target_id        = aws_instance.app_server.id
}


resource "aws_lb_listener" "sample_listener" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_target_group.arn
  }
}
