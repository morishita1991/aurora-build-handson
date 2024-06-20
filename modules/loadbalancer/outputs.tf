output "aws_lb_dns_name" {
  value = aws_lb.sample_alb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.sample_alb.zone_id
}

output "aws_lb_sample_alb_arn" {
  value = aws_lb.sample_alb.arn
}