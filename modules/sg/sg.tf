resource "aws_security_group" "aurora_sg" {
  description = "Security group for Aurora DB"
  name        = "aurora-security-group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "aurora-sg"
  }
}