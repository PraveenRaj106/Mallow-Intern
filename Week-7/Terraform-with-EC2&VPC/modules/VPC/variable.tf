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
