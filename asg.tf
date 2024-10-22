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


# --- EIP ASSOCIATION WITH EC2 ---

data "aws_autoscaling_group" "ecs" {
  name = aws_autoscaling_group.ecs.name
}

#data "aws_instances" "asg_instances_data" {
#  instance_tags = {
#    "aws:autoscaling:groupName" = aws_autoscaling_group.ecs.name
#  }
#}

resource "aws_eip_association" "ecs_eip_assoc" {
  count         = local.azs_count
  allocation_id = aws_eip.main[count.index].id
# instance_id   = element(data.aws_instances.asg_instances_data.ids, count.index)
# instance_id   = element(aws_autoscaling_group.ecs.name, count.index)
  instance_id   = element(data.aws_autoscaling_group.ecs.instances, count.index)
  depends_on    = [aws_autoscaling_group.ecs]
}
