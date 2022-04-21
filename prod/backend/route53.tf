data "aws_route53_zone" "zone" {
  name         = "goormedu-clone.com"
  private_zone = false
}

resource "aws_route53_record" "www" {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "api.goormedu-clone.com"
  type    = "A"
  
  alias {
    name                   = aws_lb.goormedu-clone-alb.dns_name
    zone_id                = aws_lb.goormedu-clone-alb.zone_id
    evaluate_target_health = true
  }
}