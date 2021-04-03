resource "aws_lb" "my-elb"{
  name = var.ELB_NAME
  internal = var.ELB_INTERNAL
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb-sg.id]
  subnet_mapping{
    subnet_id = aws_subnet.my-ecs-subnet.id
  }
  subnet_mapping{
    subnet_id = aws_subnet.my-ecs-subnet-1.id
  }
  ip_address_type = "ipv4"
}

resource "aws_lb_listener" "my-listener"{
  load_balancer_arn = aws_lb.my-elb.arn
  port = lookup(var.ELB_LISTENER_PORT,var.ELB_LISTENER_PROTOCOL)
  protocol = var.ELB_LISTENER_PROTOCOL
  default_action{
    type = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_security_group" "lb-sg"{
  vpc_id = aws_vpc.my-ecs-vpc.id
  ingress {
    description = "Allow all traffic on port 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "lb"{
  value = aws_lb.my-elb.dns_name
}
