resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    
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

resource "aws_subnet" "pub_subnet_1" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "my-public-subnet-1"
    }
}

resource "aws_subnet" "pub_subnet_2" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "my-public-subnet-2"
    }
}

resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "my-route-table"
    }
}

resource "aws_route_table_association" "pub_subnet_1" {
    subnet_id      = aws_subnet.pub_subnet_1.id
    route_table_id = aws_route_table.my_rt.id
}

resource "aws_route_table_association" "pub_subnet_2" {
    subnet_id      = aws_subnet.pub_subnet_2.id
    route_table_id = aws_route_table.my_rt.id
}

resource "aws_security_group" "my_sg" {
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "my-security-group"
    }
}

# Creating EC2 instance with custom ami and user data
resource "aws_instance" "my_instance1" {
    ami           = "ami-054e30f060ccfb328"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.pub_subnet_1.id
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    user_data     = <<-EOF
                    #!/bin/bash
                    sudo su
                    echo "Hello from instance-1
                    Hostname : $(hostname) 
                    Source ip : $(hostname -i)" > /var/www/html/index.html
                    systemctl restart nginx
                    EOF

    tags = {
        Name = "instance-1"
    }
}

resource "aws_instance" "my_instance2" {
    ami           = "ami-054e30f060ccfb328"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.pub_subnet_2.id
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    user_data     = <<-EOF
                    #!/bin/bash
                    sudo su
                    echo "Hello from instance-2
                    Hostname : $(hostname) 
                    Source ip : $(hostname -i)" > /var/www/html/index.html
                    systemctl restart nginx
                    EOF

    tags = {
        Name = "instance-2"
    }
}
# Create an Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "my-alb"
  }
}
resource "aws_lb_target_group" "my_tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "my-target-group"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "instance1" {
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = aws_instance.my_instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance2" {
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = aws_instance.my_instance2.id
  port             = 80
}


output "alb_dns_name" {
    value = aws_lb.my_alb.dns_name
}