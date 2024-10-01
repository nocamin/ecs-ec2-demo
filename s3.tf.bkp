# Create S3 bucket to store certs

resource "aws_s3_bucket" "certs_bucket" {
  bucket = "${var.aws_region}-${var.environment}-app-bucket"  # bucket name
}

#resource "aws_s3_object" "certs_object" {
#  bucket = aws_s3_bucket.certs_bucket.bucket
#  key    = "certs/"
#  source = "./certs/"  # Update this path
#}
#


locals {
  files = [for file in fileset("${path.module}/certs", "**/*") : file]
}

resource "aws_s3_object" "certs_objects" {
  for_each = toset(local.files)

  bucket = aws_s3_bucket.certs_bucket.bucket
  key    = "certs/${each.value}"
  source = "${path.module}/certs/${each.value}"
}
