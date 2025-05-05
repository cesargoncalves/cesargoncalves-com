module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "4.1.0"

  aliases = [
    "cesargoncalves.com",
    "www.cesargoncalves.com",
  ]

  comment             = "cesargoncalves"
  enabled             = true
  is_ipv6_enabled     = false
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3 = {
      domain_name           = module.s3.s3_bucket_bucket_regional_domain_name
      origin_path           = "/site"
      origin_access_control = "s3_oac"
      #origin_shield = {
      #  enabled              = true
      #  origin_shield_region = "eu-west-1"
      #}
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_name    = "Managed-CachingOptimized"
    use_forwarded_values = false

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    function_association = {
      viewer-request = {
        function_arn = aws_cloudfront_function.function.arn
      }
    }
  }

  #geo_restriction = {
  #  restriction_type = "whitelist"
  #  locations        = ["PT"]
  #}

  viewer_certificate = {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_function" "function" {
  name    = "redirect-cesargoncalves"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/function.js")
}

resource "cloudflare_dns_record" "cloudfront" {
  for_each = toset([
    "cesargoncalves.com",
    "www.cesargoncalves.com"
  ])

  zone_id = data.cloudflare_zone.zone.zone_id
  name    = each.value
  proxied = true
  content = module.cloudfront.cloudfront_distribution_domain_name
  type    = "CNAME"
  ttl     = 1
}
