variable "AWS_REGION"{
  type = string
  default = "us-east-2"
}

variable "AVAILABILITY_ZONE"{
  type = string
  default = "us-east-2b"
}

variable "VPC_CIDR"{
  type = string
}

variable "SUBNET_CIDR"{
  description = "This is for public subnet"
  type = string
}

variable "PRIVATE_CIDR"{
  description = "This is for private subnet"
  type = string
}

variable "PUBILC_IP_ON_LAUNCH"{
  type = bool
}

variable "DNS_HOSTNAME_SUPPORT"{
  type = bool
}

variable "VOLUME_SIZE"{
  type = number
}
variable "USER"{
  type = string
  default = "ec2-user"
}

variable "AMIS"{
  type = map
  default = {
    us-east-1 = "ami-0533f2ba8a1995cf9"
    us-east-2 = "ami-089c6f2e3866f0f14"
  }
}
