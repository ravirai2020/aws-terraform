provider "aws" {
  region = var.AWS_REGION
}

resource "aws_ebs_volume" "my-first-volume" {
  availability_zone = var.AVAILABILITY_ZONE
  size              = var.VOLUME_SIZE
  tags = {
    name = "terraform-volume"
  }
}

resource "aws_vpc" "my-first-vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = var.DNS_HOSTNAME_SUPPORT
  tags = {
    name = "terraform-vpc"
  }
}

resource "aws_subnet" "my-first-subnet" {
  vpc_id                  = aws_vpc.my-first-vpc.id
  cidr_block              = var.SUBNET_CIDR
  map_public_ip_on_launch = var.PUBILC_IP_ON_LAUNCH
  availability_zone       = var.AVAILABILITY_ZONE
}

resource "aws_internet_gateway" "my-first-gateway" {
  vpc_id = aws_vpc.my-first-vpc.id
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-first-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-first-gateway.id
  }
  tags = {
    name = "terraform-gateway"
  }
}

resource "aws_route_table_association" "my-first-association" {
  subnet_id      = aws_subnet.my-first-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}

resource "aws_security_group" "my-first-sg" {
  vpc_id = aws_vpc.my-first-vpc.id
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow All"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-first-instance" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type          = "t2.micro"
  key_name               = "AWSKey"
  availability_zone      = var.AVAILABILITY_ZONE
  vpc_security_group_ids = [aws_security_group.my-first-sg.id]
  subnet_id              = aws_subnet.my-first-subnet.id
  #associate_public_ip_address = "true"
  user_data = "${file("template/index.sh")}"
  }

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.my-first-volume.id
  instance_id = aws_instance.my-first-instance.id
}

output "ip"{
  value = "${aws_instance.my-first-instance.public_ip}"
}
