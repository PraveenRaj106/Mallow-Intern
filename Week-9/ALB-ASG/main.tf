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

resource "aws_security_group" "my_alb_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "my_ec2" {
    vpc_id = aws_vpc.my_vpc.id
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        security_groups = [aws_security_group.my_alb_sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "my_alb" {
    name               = "my-alb"
    load_balancer_type = "application"
    internal           = false
    security_groups    = [aws_security_group.my_alb_sg.id]
    subnets            = aws_subnet.public_subnets[*].id
    depends_on = [ aws_internet_gateway.my_igw ]
}

resource "aws_lb_target_group" "my_target_group" {
    name     = "my-target-group"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.my_vpc.id

    tags = {
        Name = "my-target-group"
    }
}

resource "aws_lb_listener" "my_listener" {
    load_balancer_arn = aws_lb.my_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my_target_group.arn
    }
    tags = {
        Name = "my-listener"
    }
}

resource "aws_launch_template" "my_launch_template" {
    name   = "my_server"
    image_id      = var.ami_id
    instance_type = var.instance_type

    network_interfaces {
        associate_public_ip_address = false
        security_groups              = [aws_security_group.my_ec2.id]
    }
    user_data = filebase64("userdata.sh")

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "my-instance"
        }
    }
}

resource "aws_autoscaling_group" "my_asg" {
    name = "my-servers-asg"
    target_group_arns = [aws_lb_target_group.my_target_group.arn]
    vpc_zone_identifier = aws_subnet.private_subnets[*].id
    min_size            = 1
    max_size            = 3
    desired_capacity    = 2

    launch_template {
        id      = aws_launch_template.my_launch_template.id
        version = "$Latest"
    }

    health_check_type          = "EC2"
  
}