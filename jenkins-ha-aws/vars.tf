# variable "az_count" {
#     type = number  
# }

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "efs_name" {
  type = string
}