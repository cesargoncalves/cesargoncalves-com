terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = local.default_tags
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "acm"

  default_tags {
    tags = local.default_tags
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
