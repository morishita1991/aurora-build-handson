variable "vpc_id" {
  type = string
}
variable "env" {
  type = string
}
variable "region" {
  type = string
}
variable "is_prd" {
  type        = bool
  description = "A Flag whether it is for the prd environment or not."
}
variable "is_osaka" {
    type        = bool
    description = "A Flag whether it is for the osaka region or not."
}
variable "global_cluster_id" {
  type = string
}
variable "subnet_group_name" {
  type = string
}
variable "master_username" {
  type = string
}
variable "master_password" {
  type = string
}
variable "performance_insights_enabled" {
  type = bool
}
variable "performance_insights_retention_period" {
  type = number
}
variable "monitoring_interval" {
  type = number
}
variable "rds_enhanced_monitoring_role_arn" {
  type = string
}
variable "cluster_preferred_maintenance_window" {
  type = string
}
variable "writer_preferred_maintenance_window" {
  type = string
}
variable "reader_preferred_maintenance_window" {
  type = string
}