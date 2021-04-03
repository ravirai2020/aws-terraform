resource "aws_autoscaling_group" "my-asg"{
  name = var.ASG_NAME
  launch_configuration = aws_launch_configuration.my-config.name
  vpc_zone_identifier = [aws_subnet.my-ecs-subnet.id,aws_subnet.my-ecs-subnet-1.id]
  target_group_arns = [aws_lb_target_group.target-group.arn]
  health_check_type = "ELB"
  desired_capacity = var.DESIRED_CAPACITY
  min_size = var.MIN_SIZE
  max_size = var.MAX_SIZE
  tag{
    key = "terraform-asg"
    value = "testing"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg-policy"{
  name = var.ASG_POLICY
  autoscaling_group_name = aws_autoscaling_group.my-asg.name
  adjustment_type = "PercentChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration{
    predefined_metric_specification{
       predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
