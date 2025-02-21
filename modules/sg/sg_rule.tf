# Aurora
resource "aws_security_group_rule" "aurora_mysql" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol         = "tcp"
  security_group_id = aws_security_group.aurora_sg.id
  cidr_blocks       = var.is_osaka ? ["10.0.0.0/16"] : ["10.1.0.0/16"]  # TODO: 必要に応じて変更
}

resource "aws_security_group_rule" "aurora_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol         = "-1"
  security_group_id = aws_security_group.aurora_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}