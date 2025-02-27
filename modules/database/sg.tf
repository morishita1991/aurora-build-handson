resource "aws_security_group" "aurora_sg" {
  description = "Security group for Aurora DB"
  name        = "aurora-sg"
  vpc_id      = var.vpc_id
  tags = {
    Name = "aurora-sg"
  }
}

resource "aws_security_group" "aurora_sql_instance_sg" {
  description = "Security group for allowing SQL access to Aurora"
  name        = "aurora-sql-access-sg"
  vpc_id      = var.vpc_id
  tags = {
    Name = "aurora-sql-access-sg"
  }
}