resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "My-VPC"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "My-IGW"
    }
}

resource "aws_eip" "my_eip" {
    domain = "vpc"
    tags = {
        Name = "My-EIP-Nat-Gateway"
    }
}

resource "aws_nat_gateway" "my_nat_gateway" {
    allocation_id = aws_eip.my_eip.id
    subnet_id    = aws_subnet.my_public_subnet.id
}

resource "aws_subnet" "my_public_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = var.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = var.public_az
    tags = {
        Name = "My-Public-Subnet"
    }
}

resource "aws_subnet" "my_private_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = var.private_subnet_cidr
    map_public_ip_on_launch = false
    availability_zone = var.private_az
    tags = {
        Name = "My-Private-Subnet"
    }
}

resource "aws_route_table" "my_public_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "My-Public-Route-Table"
    }
}

resource "aws_route_table_association" "my_public_subnet" {
    subnet_id      = aws_subnet.my_public_subnet.id
    route_table_id = aws_route_table.my_public_route_table.id
}

resource "aws_route_table_association" "my_private_subnet" {
    subnet_id      = aws_subnet.my_private_subnet.id
    route_table_id = aws_route_table.my_private_route_table.id
}

resource "aws_route_table" "my_private_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
    }
    tags = {
        Name = "My-Private-Route-Table"
    }
}
