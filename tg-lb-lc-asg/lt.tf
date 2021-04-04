resource "aws_launch_template" "my-template"{
  name = var.LT_NAME
  image_id = var.LT_AMI
  instance_type = var.LT_INSTANCE_TYPE
  key_name = "AWSKey"
  #vpc_security_group_ids = [aws_security_group.my-ecs-sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.role-instance-profile.name
  }
  block_device_mappings{
    device_name = var.LT_DEVICE_NAME
    ebs{
      volume_size = var.LT_BLOCK_SIZE
      delete_on_termination = "true"
      volume_type = var.LT_VOLUME_TYPE
      #iops = "1000"
    }
  }
  tag_specifications{
    resource_type = "instance"
    tags = {
      Name = "terraform-ec2"
    }
  }
  network_interfaces{
  #  associate_public_ip_address = "true"
  #  delete_on_termination = "true"
    security_groups = [aws_security_group.my-ecs-sg.id]
    subnet_id = aws_subnet.my-ecs-subnet.id
  }

}

output "lt_id"{
  value = aws_launch_template.my-template.id
}
