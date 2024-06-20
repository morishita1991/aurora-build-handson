output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_1a_address_id" {
  value = aws_subnet.public_subnet_1a.id
}

output "public_1c_address_id" {
  value = aws_subnet.public_subnet_1c.id
}