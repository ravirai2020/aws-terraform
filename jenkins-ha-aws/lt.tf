resource "aws_launch_template" "jenkins_lt" {
  name                   = "jenkins-template"
  description            = "Template for jenkins HA"
  image_id               = data.aws_ami.ubuntu18.id
  instance_type          = "t2.micro"
  key_name               = "AWSKey"
  user_data              = data.template_cloudinit_config.config.rendered
  vpc_security_group_ids = ["${aws_default_security_group.vpc_default.id}"]
  # ebs {
  #   volume_size = 5
  #   volume_type = "gp2"
  #   delete_on_termination = True
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "lt-${data.aws_region.current.name}"
    }
  }
  tags = {
    "Managed" = "Terraform"
    "Info"    = "Region: ${data.aws_region.current.name}"
  }

}