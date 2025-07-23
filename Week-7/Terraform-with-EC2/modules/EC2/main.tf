provider "aws" {
   alias = "mumbai"
   region = "ap-south-1"  # Set your desired AWS region
}

resource "aws_instance" "demo" {
   ami = var.ami_value  # Specify an appropriate AMI ID
   instance_type = var.instance_type_value
   key_name = "june18"
   provider = "aws.mumbai"
   

   tags = {
      Name = "DemoInstance"
   }
}

