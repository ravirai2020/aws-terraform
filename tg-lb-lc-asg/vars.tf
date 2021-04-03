variable "REPO_NAME"{
  type = string
  default = "My-Repo"
}

variable "AWS_REGION"{
  type = string
  default = "us-east-1"
}

variable "LAUNCH_CONFIG_NAME"{
  type = string
  default = "my-config"
}

variable "ECS_AMI"{
  type = map
  default = {
    us-east-1 = "ami-009b187c8747c8482"
    use-east-2 = "ami-056e373c795c34036"
  }
}

variable "LT_AMI"{
  type = string
}

variable "ECS_ROLE_FOR_EC2"{
  type = string
}

variable "VPC_CIDR"{
  type = string
}

variable "DNS_HOSTNAME_SUPPORT"{
  type = bool
}

variable "SUBNET_CIDR"{
  type = string
}

variable "SUBNET_CIDR_1"{
  type = string
}

variable "PUBILC_IP_ON_LAUNCH"{
  type = bool
}

variable "PUBLIC_IP_ON_LAUNCH_1"{
  type = bool
}

variable "AVAILABILITY_ZONE"{
  type = string
}

variable "AVAILABILITY_ZONE_1"{
  type = string
}

variable "TG_TARGET_GROUP"{
  type = string
}

variable "TG_TARGET_TYPE"{
  type = string
}

variable "TG_PROTOCOL"{
  type = string
}

variable "TG_PROTOCOL_VERSION"{
  type = map
  default = {
    HTTP = "HTTP1"
    HTTPS = "HTTP2"
  }
}

variable "TG_TARGET_GROUP_PORT"{
  type = number
}

variable "ELB_NAME"{
  type = string
}

variable "ELB_INTERNAL"{
  type = string
}

variable "ELB_LISTENER_PORT"{
  type = map
  default = {
    HTTP = "80"
    HTTPS = "443"
  }

}

variable "ELB_LISTENER_PROTOCOL"{
  type = string
}

variable "LT_NAME"{
  type = string
}

variable "LT_INSTANCE_TYPE"{
  type = string
  default = "t2.micro"
}

variable "LT_DEVICE_NAME"{
  type = string
}

variable "LT_BLOCK_SIZE"{
  type = number
}

variable "LT_VOLUME_TYPE"{
  type = string
}

variable "ASG_NAME"{
  type = string
}

variable "DESIRED_CAPACITY"{
  type = number
}

variable "MIN_SIZE"{
  type = number
}

variable "MAX_SIZE"{
  type = number
}

variable "ASG_POLICY"{
  type = string
}
