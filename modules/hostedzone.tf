resource "aws_route53_zone" "oxlava" {
  name = "oxlava.live"
}

resource "aws_route53_zone" "sub-domain-name" {
  name = "sudomain.oxlava.live"
}

resource "aws_route53_record" "lava-record" {
  zone_id = aws_route53_zone.oxlava.zone_id
  name    = "subdomain.oxlava.live"
  type    = "A"

  alias {
    name                   = aws_lb.apache-vpc-lb.dns_name
    zone_id                = aws_lb.apache-vpc-lb.zone_id
    evaluate_target_health = true
  }
  depends_on = [
    aws_lb.apache-vpc-lb
  ]
}