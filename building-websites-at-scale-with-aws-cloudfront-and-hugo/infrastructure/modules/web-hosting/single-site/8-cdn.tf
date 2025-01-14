module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.1"

  comment             = "Web Hosting for domain ${var.domain_name}"
  enabled             = true
  is_ipv6_enabled     = true
  retain_on_delete    = false
  wait_for_deployment = true

  aliases = [var.domain_name]

  create_origin_access_control = true
  origin_access_control = {
    "s3_oac_${var.site_name}" = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    media_bucket = {
      domain_name           = module.media_bucket.s3_bucket_bucket_domain_name
      origin_access_control = "s3_oac_${var.site_name}"
    }
  }

  default_root_object = "index.html"
  default_cache_behavior = {
    target_origin_id       = "media_bucket"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    function_association = {
      viewer-request = {
        function_arn = aws_cloudfront_function.this.arn
      }
    }
  }


  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = local.tags

}

module "media_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.1"

  # Allow deletion of non-empty bucket
  force_destroy = true

  restrict_public_buckets = true // #trivy:ignore
  ignore_public_acls      = true // #trivy:ignore
  block_public_policy     = true // #trivy:ignore
  block_public_acls       = true // #trivy:ignore

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true

      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

data "aws_iam_policy_document" "s3_policy" {
  # Origin Access Controls
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.media_bucket.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cdn.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.media_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
