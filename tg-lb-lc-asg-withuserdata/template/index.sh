#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
MyIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "This is from EC2 version 2.0 instance $MyIP" >> /var/www/html/index.html
