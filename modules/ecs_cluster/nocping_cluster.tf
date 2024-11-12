module "vpc" {
  source = "../vpc"
}

module "global" {
  source = "../global"
}

resource "aws_security_group" "ecs_task" {
  vpc_id = module.networking.vpc_id
}

# --- ECS Cluster ---

resource "aws_ecs_cluster" "main" {
  name = "demo-cluster"
}

# --- ECS Launch Template ---

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "demo-ecs-ec2-"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_node_sg.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }
 

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config;
       yum install -y amazon-ssm-agent
       systemctl enable amazon-ssm-agent
       systemctl start amazon-ssm-agent
    EOF
  )
}

# --- ECS Task Definition ---

resource "aws_ecs_task_definition" "app" {
  family             = "nocping-app"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  network_mode       = "host"
  volume {
    name      = "s3-data"
    host_path = "/opt/observability/nocping/certs"
  }
  cpu                = 256
  memory             = 256

  container_definitions = jsonencode([{
    name         = "nocping",
#   image        = "${aws_ecr_repository.app.repository_url}:latest",
    image        = "147997118683.dkr.ecr.us-east-1.amazonaws.com/dev/ecr01:latest",
    essential    = true,
    portMappings = [{ containerPort = 80, hostPort = 80 }],
    
    mountPoints = [{
      sourceVolume  = "s3-data",
      containerPath = "/certs"
#     readOnly      =  true
    }] 
   
    environment = [
      { name = "EXAMPLE", value = "nocping" }
    ]
    
    secrets = [
      {
        name      = "AU_EPP_USER"
        valueFrom = aws_ssm_parameter.icinga_cctld_au_epp_user.arn 
      },
      {
        name      = "AU_EPP_PASS"
        valueFrom = aws_ssm_parameter.icinga_cctld_au_epp_password.arn 
      }
    ]       
 
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = "us-east-1",
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
        "awslogs-stream-prefix" = "nocping"
      }
    },
  }])
}
