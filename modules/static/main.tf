
locals {
  bucket_name = "${var.env}-${var.site_name}"
}

resource "aws_s3_bucket" "site" {
  bucket = "${local.bucket_name}"
  acl    = "public-read"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }
    ]
}
EOF

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://${var.domain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
  
  website {
    index_document = "index.html"
    error_document = "error.html"

  }
  force_destroy = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_object" "site" {
  acl          = "public-read"
  key          = "index.html"
  bucket       = aws_s3_bucket.site.id
  content      = file("${path.module}/assets/index.html")
  content_type = "text/html"

}

