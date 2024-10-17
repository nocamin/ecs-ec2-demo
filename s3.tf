# Create S3 bucket and policy of S3 bucket

resource "aws_s3_bucket" "nocping_bucket" {
  bucket = "nocping-ecs-bucket"
}

resource "aws_s3_bucket_policy" "nocping_bucket_policy" {
  bucket = aws_s3_bucket.nocping_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "s3:ListBucket",
        Effect = "Allow",
        Resource = aws_s3_bucket.nocping_bucket.arn,          # This is for bucket-level access
        Principal = {
          AWS = aws_iam_role.ecs_task_role.arn                # Specify your IAM role here
        },
        Condition = {                                         # Optionally specify a condition if needed
          StringEquals = {
            "s3:prefix" = ""                                  # This allows listing all objects; adjust if needed
          }
        }
      },
      {
        Action = ["s3:GetObject", "s3:PutObject"],
        Effect = "Allow",
        Resource = "${aws_s3_bucket.nocping_bucket.arn}/*",     # This is for object-level access
        Principal = {
          AWS = aws_iam_role.ecs_task_role.arn                  # Specify your IAM role here
        }
      }
    ]
  })
}

# IAM Role to Access S3 Bucket and Add S3 access policy to ECS Task Role
resource "aws_iam_policy" "ecs_s3_access_policy" {
  name        = "ecs_s3_access_policy"
  description = "Policy to allow ECS task to access the S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.nocping_bucket.arn,                                  # Bucket-level access
          "${aws_s3_bucket.nocping_bucket.arn}/*"                            # Object-level access
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_s3_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_s3_access_policy.arn
}
