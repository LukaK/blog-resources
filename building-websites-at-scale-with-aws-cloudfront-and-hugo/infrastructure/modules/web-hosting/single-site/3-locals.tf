locals {
  tags = merge(
    var.tags,
    {
      SiteName   = var.site_name,
      DomainName = var.domain_name,
    }
  )
}
