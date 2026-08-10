###############################################################
# Local
###############################################################

locals {

  bucket_name = (
    var.s3_bucket_name != ""
    ? var.s3_bucket_name
    : "${var.name}-vpc-flowlogs-${data.aws_caller_identity.current.account_id}"
  )

}

data "aws_caller_identity" "current" {}

###############################################################
# S3 Bucket
###############################################################

resource "aws_s3_bucket" "flowlogs" {

  count = var.create_s3_bucket ? 1 : 0

  bucket = local.bucket_name

  force_destroy = false

  tags = merge({

    Name        = "${var.name}-flowlogs"

    Environment = var.name

    Service     = "network-observability"

    Terraform   = "true"

  }, var.tags)

}
// Bucket Versioning
resource "aws_s3_bucket_versioning" "this" {

  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.flowlogs[0].id

  versioning_configuration {

    status = var.enable_bucket_versioning ? "Enabled" : "Suspended"

  }

}
// bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  count = (
    var.create_s3_bucket &&
    var.enable_bucket_encryption
  ) ? 1 : 0

  bucket = aws_s3_bucket.flowlogs[0].id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = (
        var.kms_key_id == null
        ? "AES256"
        : "aws:kms"
      )

      kms_master_key_id = var.kms_key_id

    }

  }

}
// Public Access Block
resource "aws_s3_bucket_public_access_block" "this" {

  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.flowlogs[0].id

  block_public_acls = true

  block_public_policy = true

  ignore_public_acls = true

  restrict_public_buckets = true

}
//Lifecycle Policy
resource "aws_s3_bucket_lifecycle_configuration" "this" {

  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.flowlogs[0].id

  rule {

    id = "flowlogs"

    status = "Enabled"

    filter {}

    transition {

      days = var.s3_transition_days

      storage_class = "STANDARD_IA"

    }

    transition {

      days = var.s3_glacier_days

      storage_class = "GLACIER"

    }

    expiration {

      days = var.s3_expiration_days

    }

  }

}
// Bucket Policy

data "aws_iam_policy_document" "flowlogs_bucket" {

  statement {

    sid = "AWSLogDeliveryWrite"

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [

        "delivery.logs.amazonaws.com"

      ]

    }

    actions = [

      "s3:PutObject"

    ]

    resources = [

      "${aws_s3_bucket.flowlogs[0].arn}/*"

    ]

  }

  statement {

    sid = "AWSLogDeliveryAcl"

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [

        "delivery.logs.amazonaws.com"

      ]

    }

    actions = [

      "s3:GetBucketAcl"

    ]

    resources = [

      aws_s3_bucket.flowlogs[0].arn

    ]

  }

}

resource "aws_s3_bucket_policy" "this" {

  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.flowlogs[0].id

  policy = data.aws_iam_policy_document.flowlogs_bucket.json

}