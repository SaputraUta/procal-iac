resource "aws_route53_zone" "public" {
  name = var.public_domain
  tags = var.tags
}

resource "aws_route53_zone" "private" {
  name = var.private_domain
  vpc {
    vpc_id = var.vpc_id
  }
  tags = var.tags
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.public_domain
  subject_alternative_names = ["*.${var.public_domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.public.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}