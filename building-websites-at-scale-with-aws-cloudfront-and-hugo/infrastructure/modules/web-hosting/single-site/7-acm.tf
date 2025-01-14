module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.1.1"

  domain_name               = var.domain_name
  zone_id                   = aws_route53_zone.this.zone_id
  subject_alternative_names = [var.domain_name]

  validation_method   = "DNS"
  wait_for_validation = true

  tags = local.tags

  depends_on = [aws_route53_record.subdomain_nameservers]
}
