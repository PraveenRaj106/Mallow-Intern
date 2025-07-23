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
variable "sg" {
   description = "Security-Group"
   type = string
}
variable "subnet" {
   description = "Subnet-id"
   type = string
}
