data "aws_caller_identity" "current" {
}

data "aws_elb_service_account" "main" {
}

# Based on: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::logs-${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "arn:aws:s3:::logs-${var.s3_bucket_name}"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_elb_service_account.main.id}:root"]
    }
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::logs-${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition {
      test = "StringEquals"
      values = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }

  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::logs-${var.s3_bucket_name}"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}
