output "route53_zone_main_name" {
  value = data.aws_route53_zone.main.name
}

output "route53_zone_main_zone_id" {
  value = data.aws_route53_zone.main.zone_id
}