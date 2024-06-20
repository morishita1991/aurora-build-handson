resource "aws_acm_certificate" "cert" {
  domain_name               = var.route53_zone_main_name
  subject_alternative_names = ["*.${var.route53_zone_main_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}