provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
    source = "./modules/VPC"
    vpc_name = var.vpc_name
    vpc_cidr    = var.vpc_cidr
    subnet_cidr = var.subnet_cidr
    subnet_name = var.subnet_name
    igw_name    = var.igw_name
    az          = var.az
}

module "ec2" {
    source = "./modules/EC2"
    ami_id = var.ami_id
    instance_name = var.instance_name
    instance_type = var.instance_type
    key_name = var.key_name
    subnet = module.vpc.subnet_id
    sg = module.vpc.sg_id
}
output "public_ip" {
    value = module.ec2.output
}