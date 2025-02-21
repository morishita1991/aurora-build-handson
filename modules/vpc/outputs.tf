output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_group_name" {
  value = aws_db_subnet_group.subnet_group.name
}