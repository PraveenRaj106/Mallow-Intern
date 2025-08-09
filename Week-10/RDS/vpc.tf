# VPC Configuration
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.my_vpc.id
  count             = length(var.az)
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + 1)
  availability_zone = var.az[count.index]

  tags = {
    Name = "my-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.my_vpc.id
  count             = length(var.az)
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + 3)
  availability_zone = var.az[count.index]

  tags = {
    Name = "my-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "my-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnets_association" {
  route_table_id = aws_route_table.public_rt.id
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

resource "aws_eip" "elastic_ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = element(aws_subnet.public_subnets[*].id, 0)
  depends_on    = [aws_internet_gateway.my_igw]

  tags = {
    Name = "my-nat-gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id     = aws_vpc.my_vpc.id
  depends_on = [aws_nat_gateway.my_nat_gateway]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "my-private-route-table"
  }
}

resource "aws_route_table_association" "private_rt" {
  route_table_id = aws_route_table.private_rt.id
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}

resource "aws_security_group" "my_db_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "my-db-sg"

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-DB-SG"
  }
}