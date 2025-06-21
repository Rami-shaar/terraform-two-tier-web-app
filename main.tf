terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-rami2"
    key            = "my-terraform-state-bucket-rami2/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-lock-id"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/VPC"
  vpc_cidr             = var.vpc_cidr
  region               = var.region
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}

module "compute" {
  source              = "./modules/Compute"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  ami_id              = var.ami_id
  instance_type       = var.instance_type
}
