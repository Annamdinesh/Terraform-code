variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-0ab4d1e9cf9a1215a"
}

variable "vpc_cidr" {
  default = "10.0.1.0/24"
}

variable "vpc_name" {
  default = "prod_vpc"
}

variable "aws_internet_gateway" {
  default = "prod_IGW"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet_name" {
  default = "prod_subnet1"
}

variable "main_routing_table" {
  default = "prod_main_table"
}

variable "aws_security_group" {
  default = "prod-sg-ssh"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "Jenkins_key"
}
variable "environment" {
  default = "prod"
}
# terraform plan -var-file = "var.tfvars"





