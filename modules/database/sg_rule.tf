# Aurora
resource "aws_security_group_rule" "ingress_aurora" {
  from_port         = "3306"
  protocol         = "tcp"
  security_group_id = aws_security_group.aurora_sg.id
  source_security_group_id = aws_security_group.aurora_sql_instance_sg.id
  to_port           = "3306"
  type              = "ingress"
}

resource "aws_security_group_rule" "egress_aurora" {
  from_port         = "0"
  protocol          = "-1"
  security_group_id = aws_security_group.aurora_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = "0"
  type              = "egress"
}

# Aurora SQL Instance
resource "aws_security_group_rule" "egress_aurora_sql_instance" {
  from_port         = "0"
  protocol          = "-1"
  security_group_id = aws_security_group.aurora_sql_instance_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = "0"
  type              = "egress"
}