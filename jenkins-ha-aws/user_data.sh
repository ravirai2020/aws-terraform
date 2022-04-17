#!/bin/bash

MYAZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
sudo apt-get -y update
sudo apt-get install -y nfs-common
sudo apt-get install -y unzip
sudo apt-get install -y openjdk-11-jdk
sudo useradd -d /var/lib/jenkins -s /bin/bash -U -m jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
sudo echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get -y update
sudo apt install -y fontconfig
sudo apt install -y openjdk-11-jre
sudo apt install -y jenkins
sudo systemctl stop jenkins
sudo mount -t nfs4 -o vers=4.1 $MYAZ.${efs}:/ /var/lib/jenkins
sudo echo ${efs}:/ /var/lib/jenkins nfs defaults,vers=4.1 0 0 >> /etc/fstab
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo systemctl start jenkins
