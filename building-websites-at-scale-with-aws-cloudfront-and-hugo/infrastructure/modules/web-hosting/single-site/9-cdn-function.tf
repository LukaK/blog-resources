resource "aws_cloudfront_function" "this" {
  name    = "fix-url-${var.site_name}"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/code/fix_urls.js")
}
