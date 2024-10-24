# --- ECS Node Role ---

data "aws_iam_policy_document" "ecs_node_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_node_role" {
  name_prefix        = "demo-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_node_role_policy" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_node_ssm_policy" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"  # Predefined SSM policy for Instance
}

resource "aws_iam_policy" "ecs_eip_assoc" {
  name        = "EIPAssociationPolicy"
  description = "Policy to allow EIP association to EC2 instances"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress",
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:DescribeAddresses",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_eip_assoc" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = aws_iam_policy.ecs_eip_assoc.arn  # Custom EIP policy
}

resource "aws_iam_policy" "observability_s3" {
  name   = "observability-s3"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "observability_s3" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = aws_iam_policy.observability_s3.arn    # Custom S3 Policy
}

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "demo-ecs-node-profile"
  path        = "/ecs/instance/"
  role        = aws_iam_role.ecs_node_role.name
}


# --- ECS Task Role ---

data "aws_iam_policy_document" "ecs_task_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name_prefix        = "demo-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role" "ecs_exec_role" {
  name_prefix        = "demo-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_policy" {
  role       = aws_iam_role.ecs_exec_role.name                 
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"   # Predefined SSM policy for task
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
