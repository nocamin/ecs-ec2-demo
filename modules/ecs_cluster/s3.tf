resource "aws_s3_bucket" "nocping" {
  bucket = "${var.aws_account_id}-${var.aws_region}-observability-apps"
# count  = var.aws_region == var.bucket_region ? 1 : 0
  count  = provider.aws.region == var.aws_region ? 1 : 0
  tags = {
    Name        = "nocping"
    Environment = "Dev"
  }
}

#resource "aws_s3_bucket_acl" "my_bucket_acl" {
#  bucket = aws_s3_bucket.nocping.id
#  acl    = "private"
#}

#resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
#  bucket = aws_s3_bucket.my_bucket.id
#
#  versioning_configuration {
#    enabled = true
#  }
#}
