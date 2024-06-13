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