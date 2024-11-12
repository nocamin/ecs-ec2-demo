resource "aws_s3_bucket" "nocping" {
  bucket = "${var.aws_account_id}-${var.aws_region}-observability-apps"

  tags = {
    Name        = "nocping"
    Environment = "${var.environment}"
  }
}
