resource "aws_vpc" "my-ecs-vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = var.DNS_HOSTNAME_SUPPORT
  tags = {
    name = "terraform-vpc"
  }
}

resource "aws_subnet" "my-ecs-subnet" {
  vpc_id                  = aws_vpc.my-ecs-vpc.id
  cidr_block              = var.SUBNET_CIDR
  map_public_ip_on_launch = var.PUBILC_IP_ON_LAUNCH
  availability_zone       = var.AVAILABILITY_ZONE
}

resource "aws_subnet" "my-ecs-subnet-1" {
  vpc_id                  = aws_vpc.my-ecs-vpc.id
  cidr_block              = var.SUBNET_CIDR_1
  map_public_ip_on_launch = var.PUBLIC_IP_ON_LAUNCH_1
  availability_zone       = var.AVAILABILITY_ZONE_1
}

resource "aws_internet_gateway" "my-ecs-gateway" {
  vpc_id = aws_vpc.my-ecs-vpc.id
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-ecs-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-ecs-gateway.id
  }
  tags = {
    name = "terraform-gateway"
  }
}

resource "aws_route_table_association" "my-first-association" {
  subnet_id      = aws_subnet.my-ecs-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}

resource "aws_route_table_association" "my-first-association-1" {
  subnet_id      = aws_subnet.my-ecs-subnet-1.id
  route_table_id = aws_route_table.my-route-table.id
}

resource "aws_security_group" "my-ecs-sg" {
  vpc_id = aws_vpc.my-ecs-vpc.id
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
    #cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
