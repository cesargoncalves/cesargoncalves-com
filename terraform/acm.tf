module "acm" {
  source  = "cesargoncalves/acm-cloudflare/aws"
  version = "0.1.0"

  providers = {
    aws = aws.acm
  }

  zone_name                 = "cesargoncalves.com"
  domain_name               = "cesargoncalves.com"
  subject_alternative_names = ["*.cesargoncalves.com"]
}
