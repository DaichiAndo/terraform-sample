# ==================================
# route53
# ==================================
data "aws_route53_zone" "route53_zone" {
  zone_id = var.route_53_zone_id
}

resource "aws_route53_record" "route53_api_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "api.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "route53_ui_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = var.domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cf.domain_name
    zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
    evaluate_target_health = true
  }
}
