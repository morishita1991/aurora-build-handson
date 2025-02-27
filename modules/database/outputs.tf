output "aws_security_group_aurora_sg_id" {
  value = aws_security_group.aurora_sg.id
}
output "cluster_id" {
  value = aws_rds_cluster.aurora.id
}