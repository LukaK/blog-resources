output "media_bucket_name" {
  description = "Name of the media bucket"
  value       = module.media_bucket.s3_bucket_id
}

output "site_name" {
  description = "Name of the website"
  value       = var.site_name
}
