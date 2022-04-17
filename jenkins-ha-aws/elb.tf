resource "aws_security_group" "elb_sec_group" {
  name   = "alb-sg"
  vpc_id = aws_vpc.my_vpc.id
  ingress = [{
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    protocol         = "tcp"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    description      = "Allow traffic from internet on port 80"
  }]
  egress = [{
    cidr_blocks      = []
    description      = "Allow traffic from ALB to listener port"
    from_port        = 80
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = [aws_default_security_group.vpc_default.id]
    self             = false
    to_port          = 80
    },
    {
      cidr_blocks      = []
      description      = "Allow traffic from ALB to health check port"
      from_port        = 8080
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = [aws_default_security_group.vpc_default.id]
      self             = false
      to_port          = 8080
  }]
  tags = {
    "Name"        = "ALB-sec-group"
    "Description" = "Managed By Terraform"
  }
}

resource "aws_lb_target_group" "lb_tg" {
  name             = "${var.efs_name}-tg"
  protocol         = "HTTP"
  port             = "8080"
  vpc_id           = aws_vpc.my_vpc.id
  protocol_version = "HTTP1"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "403"
    interval            = 15
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "lb_listen" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

resource "aws_lb" "jenkins_alb" {
  name               = "${var.efs_name}-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = data.aws_subnets.public_subnet.ids
  security_groups    = [aws_security_group.elb_sec_group.id]
  tags = {
    "Managed By" = "Terraform"
    "VPC info"   = "${aws_vpc.my_vpc.id}"
  }
}