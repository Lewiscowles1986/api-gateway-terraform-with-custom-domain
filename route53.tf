data "aws_route53_zone" "public" {
  zone_id      = var.HOSTED_ZONE_ID
  private_zone = false
}

resource "aws_route53_record" "api_validation" {
  for_each        = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name        = dvo.resource_record_name
      record      = dvo.resource_record_value
      type        = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public.zone_id
}

resource "aws_route53_record" "api" {
  name                     = aws_api_gateway_domain_name.api.domain_name
  type                     = "A"
  zone_id                  = data.aws_route53_zone.public.zone_id

  alias {
    name                   = aws_api_gateway_domain_name.api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api.regional_zone_id
    evaluate_target_health = false
  }
}
