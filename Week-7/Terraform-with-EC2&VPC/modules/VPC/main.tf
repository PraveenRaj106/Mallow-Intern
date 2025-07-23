provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "pub_sub" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.az
    map_public_ip_on_launch = true

    tags = {
        Name = var.subnet_name
    }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id 

    tags = {
      Name = var.igw_name
    }
}

data "aws_route_table" "default_rt" {
  vpc_id = aws_vpc.vpc.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

resource "aws_route" "Route" {
  route_table_id = data.aws_route_table.default_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_security_group" "sg" {
  name   = "SG"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "subnet_id" {
  value = aws_subnet.pub_sub.id
}
output "sg_id" {
  value = aws_security_group.sg.id
}
