resource "aws_launch_configuration" "my-config"{
  name = var.LT_NAME
  image_id = var.LT_AMI
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.role-instance-profile.name
  key_name = "AWSKey"
  security_groups = [aws_security_group.my-ecs-sg.id]

  ebs_block_device{
    volume_size = var.LT_BLOCK_SIZE
    device_name = var.LT_DEVICE_NAME
    delete_on_termination = "true"
  }
}
