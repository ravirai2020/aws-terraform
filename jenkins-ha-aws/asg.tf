resource "aws_autoscaling_group" "jenkins_asg" {
  name = "${var.efs_name}-asg"
  launch_template {
    id      = aws_launch_template.jenkins_lt.id
    version = "$Latest"
  }
  desired_capacity = "1"
  min_size         = "1"
  max_size         = "1"
  tag {
    key                 = "Managed By"
    value               = "Terraform"
    propagate_at_launch = true
  }
  vpc_zone_identifier = data.aws_subnets.public_subnet.ids
  health_check_type   = "ELB"
  target_group_arns   = ["${aws_lb_target_group.lb_tg.id}"]
}
