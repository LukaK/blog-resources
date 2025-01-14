variable "site_name" {
  description = "Website name"
  type        = string
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "primary_zone_id" {
  type        = string
  description = "Primary zone id"
}

variable "primary_zone_record_name" {
  type        = string
  description = "Record name for the primary zone"
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
