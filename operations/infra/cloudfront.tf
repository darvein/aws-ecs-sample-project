locals {
  price_class              = "PriceClass_100"
  origin_domain_name       = module.alb.this_lb_dns_name
  origin_id                = "${var.project_name}web"
  origin_path              = ""
  origin_http_port         = 80
  origin_https_port        = 443
  origin_protocol_policy   = "match-viewer"
  origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
  origin_keepalive_timeout = 60
  origin_read_timeout      = 60

  allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods   = ["GET", "HEAD"]
  target_origin_id = "${local.origin_id}"
  compress         = false

  viewer_protocol_policy = "allow-all" # redirect-to-https
  default_ttl            = 60
  min_ttl                = 0
  max_ttl                = 31536000

  acm_certificate_arn = ""
}


resource "aws_cloudfront_distribution" "cdn" {
  enabled     = true
  price_class = "${local.price_class}"

  origin {
    domain_name = "${local.origin_domain_name}"
    origin_id   = "${local.origin_id}"
    origin_path = "${local.origin_path}"

    custom_origin_config {
      http_port                = "${local.origin_http_port}"
      https_port               = "${local.origin_https_port}"
      origin_protocol_policy   = "${local.origin_protocol_policy}"
      origin_ssl_protocols     = "${local.origin_ssl_protocols}"
      origin_keepalive_timeout = "${local.origin_keepalive_timeout}"
      origin_read_timeout      = "${local.origin_read_timeout}"
    }
  }

  default_cache_behavior {
    allowed_methods  = "${local.allowed_methods}"
    cached_methods   = "${local.cached_methods}"
    target_origin_id = "${local.origin_id}"
    compress         = "${local.compress}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "${local.viewer_protocol_policy}"
    default_ttl            = "${local.default_ttl}"
    min_ttl                = "${local.min_ttl}"
    max_ttl                = "${local.max_ttl}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = "${local.acm_certificate_arn == "" ? true : false}"
  }
}
