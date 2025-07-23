provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "./modules/EC2"
  ami_value = "ami-0a1235697f4afa8a4" # replace this
  instance_type_value = "t2.micro"
}


