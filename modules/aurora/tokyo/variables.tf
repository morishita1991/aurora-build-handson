variable "env" {
  type = string
}
variable "is_prd" {
  type        = bool
  description = "A Flag whether it is for the prd environment or not."
}
variable "global_cluster_id" {
  type = string
}
variable "subnet_group_name" {
  type = string
}
variable "aws_security_group_aurora_sg_id" {
  type = string
}
variable "rds_enhanced_monitoring_role_arn" {
  type = string
}