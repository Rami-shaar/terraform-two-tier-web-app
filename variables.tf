variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type = string
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

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2s"
  default     = "t2.micro"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create (not the backend bucket!)"
}
