provider "aws" {
  shared_credentials_files = ["/Users/ravirai/.aws/credentials"]
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
    info = "Region: ${data.aws_region.current.name}"
  }
}


resource "aws_default_security_group" "vpc_default" {
  vpc_id = aws_vpc.my_vpc.id
  #name = "Default SG"
  #description = "SG for EC2"
  ingress = [{
      cidr_blocks      = []
      description      = "Allow traffic on all port on EC2"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = true
      to_port          = 0
  }]
  egress = [{
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
    description      = "To allow outbound traffic on port 2049 for EFS"
    from_port        = 2049
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 2049
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "To allow outbound traffic on all port"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
  }]
  tags = {
    Name = "Default"
    Managed = "Terraform"
   }
}

resource "aws_security_group_rule" "sg_def_1" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow SSH from anywhere"
  security_group_id = aws_default_security_group.vpc_default.id
}

resource "aws_security_group_rule" "sg_def_2" {
  type = "ingress"
  description = "Allow traffic from ALB on port 8080"
  source_security_group_id = aws_security_group.elb_sec_group.id
  to_port = 8080
  from_port = 8080
  protocol = "tcp"
  security_group_id = aws_default_security_group.vpc_default.id
}

resource "aws_security_group_rule" "sg_def_3" {
  type = "ingress"
  description = "Allow traffic from EFS on port 2049"
  source_security_group_id = aws_security_group.efs_sec_group.id
  to_port = 2049
  from_port = 2049
  protocol = "tcp"
  security_group_id = aws_default_security_group.vpc_default.id
}

resource "aws_subnet" "public_subnet" {
  #for_each                = toset(var.public_subnet_cidr)
  #cidr_block              = each.value
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone = data.aws_availability_zones.all_azs.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${aws_vpc.my_vpc.id}-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "${aws_vpc.my_vpc.id}-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "${aws_vpc.my_vpc.id}-rt"
  }
}

resource "aws_route" "rt_entry" {
  route_table_id         = aws_route_table.rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# resource "aws_route_table_association" "rt_sub" {
#     route_table_id = aws_route_table.rt.id
#    for_each       = toset(data.aws_subnets.public_subnet.ids)
#    subnet_id      = each.value
#  }

resource "aws_route_table_association" "vpc_rt" {
  #for_each       = toset(var.public_subnet_cidr)
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}