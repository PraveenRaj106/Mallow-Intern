variable "instance_type_value" {
   description = "EC2 Instance type"
   type = string
   default = "t2.micro"
}
variable "ami_value" {
   description = "EC2 AMI ID"  # enter the input as 'ami-0a1235697f4afa8a4'
   type = string
}
