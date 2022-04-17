# output "region_name" {
#     value = data.aws_region.current.name
# }

#output "vpc_id" {
#     value = data.aws_vpcs.vpcs.ids 
# }

# output "azs" {
#   value = data.aws_availability_zones.all_azs.names
# }

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = data.aws_subnets.public_subnet.ids
}

output "efs_dns" {
  value = aws_efs_file_system.jenkins_efs.dns_name
}

output "lt" {
  value = aws_launch_template.jenkins_lt.id
}

output "asg_id" {
  value = aws_autoscaling_group.jenkins_asg.id
}

output "asg_subnets" {
  value = data.aws_subnets.public_subnet.ids
}

output "alb_name" {
  value = aws_lb.jenkins_alb.dns_name
}