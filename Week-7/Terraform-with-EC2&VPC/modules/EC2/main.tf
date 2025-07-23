provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet
    security_groups = [var.sg]


    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:\\Users\\prave\\Downloads\\june18.pem")
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo yum update -y",
            "sudo yum install nginx -y",
            "sudo systemctl enable nginx",
            "sudo systemctl start nginx"
         ]
    }

    tags = {
        Name = var.instance_name
    }
}


output "output" {
   description = "Public IP of EC2 Instance"
   value = aws_instance.ec2.public_ip
}
