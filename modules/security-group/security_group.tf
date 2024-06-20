# security_group.tf

# ---------------------------------------------
# Security Group
# ---------------------------------------------
# opmng security group
resource "aws_security_group" "opmng_sg" {
  name        = "${var.project}-${var.environment}-opmng-sg"
  description = "Operation Management Security Group"
  vpc_id      = var.vpc_id
#  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-opmng-sg"
    Project = var.project
    Env     = var.environment
  }
}

# インバウンドルール追加(ポート：22)
resource "aws_security_group_rule" "opmng_in_ssh" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  cidr_blocks       = ["0.0.0.0/0"]
}

# インバウンドルール追加(ポート：80)
resource "aws_security_group_rule" "opmng_in_http" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.http_port
  to_port           = var.http_port
  cidr_blocks       = ["0.0.0.0/0"]
}

# アウトバウンドルール追加(ポート：80)
#resource "aws_security_group_rule" "opmng_out_http" {
#  security_group_id = aws_security_group.opmng_sg.id
#  type              = "egress"
#  protocol          = "tcp"
#  from_port         = var.http_port
#  to_port           = var.http_port
#  cidr_blocks       = ["0.0.0.0/0"]
#}

# アウトバウンドルール追加(全て)
resource "aws_security_group_rule" "opmng_out_all" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


# インバウンドルール追加(ポート：443)
resource "aws_security_group_rule" "opmng_in_https" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.https_port
  to_port           = var.https_port
  cidr_blocks       = ["0.0.0.0/0"]
}

# アウトバウンドルール追加(ポート：443)
#resource "aws_security_group_rule" "opmng_out_https" {
#  security_group_id = aws_security_group.opmng_sg.id
#  type              = "egress"
#  protocol          = "tcp"
#  from_port         = var.https_port
#  to_port           = var.https_port
#  cidr_blocks       = ["0.0.0.0/0"]
#}