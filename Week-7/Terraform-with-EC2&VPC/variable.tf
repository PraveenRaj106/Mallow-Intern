variable "vpc_cidr" {
    description = "vpc-cidr"
    type = string

}
variable "subnet_cidr" {
    description = "subnet-cidr"
}
variable "vpc_name" {
    description = "Name"
    type = string
}
variable "subnet_name" {
    description = "Name"
    type = string
}
variable "igw_name" {
    description = "Name"
    type = string
}
variable "az" {
    description = "Availability-Zone"
    type = string
}

variable "instance_type" {
   description = "EC2 Instance type" # enter the input as 't2.micro'
   type = string
}
variable "ami_id" {
   description = "EC2 AMI ID"  # enter the input as 'ami-0a1235697f4afa8a4'
   type = string
}
variable "key_name" {
   description = "Key Pair"
   type = string
   default = null
}
variable "instance_name" {
  description = "Instance name"
  type = string
}

