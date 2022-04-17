This terraform script creates HA Jenkins setup in AWS.
It takes VPC cidr block, 2 public subnet cidr block and EFS filesystem name as input. It craetes following-

1. VPC
2. 2 Public Subnet
3. Internet Gateway
4. Route Table and its entries
5. Security Group for VPC, EFS and ALB with entries
6. EFS file system and network mounts
7. Launch Template
8. Auto Scaling Group with max,min and desired capacity as 1 EC2 instance
9. Application Load Balancer

It outputs following details-

1. VPC id
2. Subnet ids
3. EFS dns name
4. Launch Template id
5. Auto Scaling Group id
6. Auto Scaling Group associated subnet id(same as 5)
7. Application Load Balancer dns name

Jenkins will be accessible through load balancer dns name. User data file installs relevant packages ,mounts EFS share on /var/lib/jenkins directory and start jenkins on EC2 instance.