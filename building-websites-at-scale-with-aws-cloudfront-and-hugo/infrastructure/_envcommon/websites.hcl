locals {
  sites = [
    {
      site_name                = "site1"
      domain_name              = "www.site1.com"
      primary_zone_id          = ""
      primary_zone_record_name = "www"
    },
    {
      site_name                = "site2"
      domain_name              = "www.site2.com"
      primary_zone_id          = ""
      primary_zone_record_name = "www"
    }
  ]
}
