variable "sites" {
  description = "Sites configuration"
  type = list(object(
    {
      site_name                = string
      domain_name              = string
      primary_zone_id          = string
      primary_zone_record_name = string
    }
  ))
}

variable "primary_zone_record_ttl" {
  type        = number
  description = "Time to live for the dns record"
  default     = 172800
}

variable "primary_zone_ns_record_type" {
  type        = string
  description = "Primary zone record type for name servers"
  default     = "NS"
}

variable "tags" {
  type    = map(string)
  default = {}
}
