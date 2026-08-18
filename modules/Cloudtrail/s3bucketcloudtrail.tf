resource "s3_bucket" "cloudtrail_logs" {
    bucket = var.audit_bucket_name
}

resource "s3-bucket_versioning" "cloudtrail_logs" {
    bucket = s3_bucket.cloudtrail_logs.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
    bucket = s3_bucket.cloudtrail_logs.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "s3_bucket_public_access_block" "cloudtrail_logs" {
    bucket = s3_bucket.cloudtrail_logs.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

