resource "aws_lb_target_group" "target-group"{
  name = var.TG_TARGET_GROUP
  target_type = var.TG_TARGET_TYPE
  port = var.TG_TARGET_GROUP_PORT
  vpc_id = aws_vpc.my-ecs-vpc.id
  protocol = var.TG_PROTOCOL
  protocol_version = lookup(var.TG_PROTOCOL_VERSION,var.TG_PROTOCOL)
  tags = {
    name = "terraform"
  }
  health_check{
    interval = 30
    path = "/"
    healthy_threshold = 5
    unhealthy_threshold = 3
    timeout = 10
    matcher = "200"
  }
}
