# --- ECS ASG ---

resource "aws_autoscaling_group" "ecs" {
  name_prefix               = "demo-ecs-asg-"
  vpc_zone_identifier       = aws_subnet.public[*].id
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "demo-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
  
  tag {
    key                 = "SSMAssociation"  
    value               = "${var.environment}-ssm-association" 
    propagate_at_launch = true
  }
}


# --- EIP ASSOCIATION WITH EC2 --

# Step 1: Use data source to fetch EC2 instances with a specific tag from the ASG

data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:SSMAssociation"
    values = ["${var.environment}-ssm-association"]
  }
}

# Step 2: Associate EIP with the filtered EC2 instances based on tags

resource "aws_eip_association" "ecs_eip_assoc" {
  count         = length(data.aws_instances.asg_instances.ids)
  allocation_id = aws_eip.main[count.index].id
  instance_id   = element(data.aws_instances.asg_instances.ids, count.index)
  depends_on    = [aws_autoscaling_group.ecs]
}

