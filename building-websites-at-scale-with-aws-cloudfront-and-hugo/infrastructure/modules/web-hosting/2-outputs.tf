output "content_buckets" {
  description = "Lookup map of sites with content bucket names"
  value       = { for out in module.site : out.site_name => out.media_bucket_name }
}
