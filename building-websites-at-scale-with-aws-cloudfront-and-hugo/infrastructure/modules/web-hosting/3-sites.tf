module "site" {
  for_each = { for index, site in var.sites : site.domain_name => site }
  source   = "./single-site/"

  providers = {
    aws.network = aws.network
  }

  domain_name = each.value.domain_name
  site_name   = each.value.site_name

  primary_zone_id          = each.value.primary_zone_id
  primary_zone_record_name = each.value.primary_zone_record_name

  primary_zone_record_ttl     = var.primary_zone_record_ttl
  primary_zone_ns_record_type = var.primary_zone_ns_record_type

  tags = var.tags
}
