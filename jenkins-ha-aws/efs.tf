resource "aws_efs_file_system" "jenkins_efs" {
  creation_token = var.efs_name
  tags = {
    "Name"        = "jenkins_efs"
    "Managed"     = "Terraform"
    "Description" = "Shared efs for jenkins"
  }
  encrypted = false
  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }
}

resource "aws_security_group" "efs_sec_group" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "${var.efs_name}-sec"
  ingress = [{
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
    description      = "allow traffic from EC2 sec-group on port 2049 to EFS sec-group"
    from_port        = 2049
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = [aws_default_security_group.vpc_default.id]
    self             = false
    to_port          = 2049
  }]
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow traffic to internet"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]
  tags = {
    "Name"        = "efs-sec-group"
    "Description" = "Managed by Terraform"
  }
}

resource "aws_efs_mount_target" "mount_efs" {
  file_system_id  = aws_efs_file_system.jenkins_efs.id
  security_groups = [aws_security_group.efs_sec_group.id]
  #for_each        = toset(var.public_subnet_cidr)
  count = length(var.public_subnet_cidr)
  subnet_id       = aws_subnet.public_subnet[count.index].id
}
