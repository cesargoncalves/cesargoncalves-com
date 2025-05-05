data "aws_iam_policy_document" "s3" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.s3.s3_bucket_arn}/site/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = module.s3.s3_bucket_id
  policy = data.aws_iam_policy_document.s3.json
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.8.0"

  bucket = "cloudfront-cesargoncalves"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  #attach_policy = true
  #policy        = data.aws_iam_policy_document.s3.json
}
