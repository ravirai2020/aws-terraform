data "aws_region" "current" {}

data "aws_vpcs" "vpcs" {}

data "aws_availability_zones" "all_azs" {
  state = "available"
}

data "aws_vpc" "vpc_id" {
  id = aws_vpc.my_vpc.id
}
data "aws_subnets" "public_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc_id.id]
  }
}

data "aws_ami" "ubuntu18" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "template_file" "script" {
  template = file("user_data.sh")

  vars = {
    efs = "${aws_efs_file_system.jenkins_efs.dns_name}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/x-shellscript"
    content      = data.template_file.script.rendered
  }
}