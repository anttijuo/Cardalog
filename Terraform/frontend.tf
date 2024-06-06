provider "aws" {
  region = "eu-north-1"
  alias = "frontend"
}

resource "random_pet" "frontend_bucket_suffix" {
  length    = 2
  separator = "-"
}

resource "aws_s3_bucket_website_configuration" "cardalog_html_bucket" {
  bucket = "cardalog-html-bucket-${random_pet.frontend_bucket_suffix.id}"
  acl    = "public-read"

  index_document {
    suffix = "index.html"
  }

  #error_document {
  #  key = "error.html"
  #}

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_object" "cardalog_index_html" {
  bucket = aws_s3_bucket_website_configuration.cardalog_html_bucket.bucket
  key    = "index.html"
  source = "../Frontend/index.html"
  acl    = "public-read"
  content_type = "text/html"
}

# Optional: Upload an error HTML file
#resource "aws_s3_bucket_object" "error_html" {
#  bucket = aws_s3_bucket.html_bucket.bucket
#  key    = "error.html"
#  source = "path/to/your/error.html"
#  acl    = "public-read"
#  content_type = "text/html"
#}

resource "aws_s3_bucket_policy" "cardalog_html_bucket_policy" {
  bucket = aws_s3_bucket_website_configuration.cardalog_html_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket_website_configuration.cardalog_html_bucket.id}/*"
      }
    ]
  })
}

resource "aws_cloudfront_origin_access_identity" "cardalog_origin_access_identity" {
  comment = "Origin Access Identity for S3 bucket"
}

resource "aws_cloudfront_distribution" "cardalog_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.cardalog_html_bucket.website_domain
    origin_id   = aws_s3_bucket_website_configuration.cardalog_html_bucket.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cardalog_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket_website_configuration.cardalog_html_bucket.bucket

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.cardalog_html_bucket.website_endpoint
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cardalog_s3_distribution.domain_name
}
