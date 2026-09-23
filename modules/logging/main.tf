locals {
  trail_arn = "arn:aws:cloudtrail:${var.aws_region}:${var.management_account_id}:trail/${var.trail_name}"
}

resource "aws_s3_bucket" "audit_logs" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name      = var.bucket_name
    Project   = "aws-multi-account-landing-zone"
    ManagedBy = "Terraform"
    Purpose   = "CentralizedAuditLogs"
  }
}

resource "aws_s3_bucket_versioning" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.audit_logs.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "s3:GetBucketAcl"

        Resource = aws_s3_bucket.audit_logs.arn

        Condition = {
          StringEquals = {
            "aws:SourceArn" = local.trail_arn
          }
        }
      },

      {
        Sid    = "AWSCloudTrailManagementAccountWrite"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.audit_logs.arn}/AWSLogs/${var.management_account_id}/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "aws:SourceArn" = local.trail_arn
          }
        }
      },

      {
        Sid    = "AWSCloudTrailOrganizationWrite"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.audit_logs.arn}/AWSLogs/${var.organization_id}/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control"
            "aws:SourceArn" = local.trail_arn
          }
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "organization" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.audit_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail
  ]

  tags = {
    Name      = var.trail_name
    Project   = "aws-multi-account-landing-zone"
    ManagedBy = "Terraform"
    Purpose   = "OrganizationAudit"
  }
}