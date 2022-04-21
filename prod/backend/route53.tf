data "aws_route53_zone" "zone" {
  name         = "goormedu-clone.com"
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "api.goormedu-clone.com"
  type    = "A"
  ttl     = "300"
  records  = [aws_lb.goormedu-clone-alb.dns_name]
}