variable "vpc_cidr" {
  type = string
}

variable "region" {
  type = string
  description = "Region prefix (e.g., eu-west-2)"
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

