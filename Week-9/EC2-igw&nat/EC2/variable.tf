variable "public_subnet_id" {
    description = "ID of the public subnet"
    type        = string
}

variable "private_subnet_id" {
    description = "ID of the private subnet"
    type        = string
}
variable "instance_type" {
    description = "Type of EC2 instance"
    type        = string
    default     = "t2.micro"
}
variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    type        = string
    default     = "ami-0d0ad8bb301edb745" # Replace with a valid AMI ID
  
}

