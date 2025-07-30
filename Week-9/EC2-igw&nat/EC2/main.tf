resource "aws_instance" "ec2_public" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.public_subnet_id
    tags = {
        Name = "EC2-Public-Instance"
    }
}

resource "aws_instance" "ec2_private" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.private_subnet_id
    tags = {
        Name = "EC2-Private-Instance"
    }
}
