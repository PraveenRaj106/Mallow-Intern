resource "aws_launch_template" "ecs_ec2" {
    name = "ecs-ec2"
    image_id = var.img-id
    instance_type = var.instance_type
    iam_instance_profile {
        arn = aws_iam_instance_profile.ecs_instance_profile.arn
    }
    
    key_name = var.key
    network_interfaces {
        associate_public_ip_address  = true
        security_groups              = [aws_security_group.ecs_sg.id]
        
    }

     user_data = filebase64("user_data.sh")

    # user_data = base64encode(<<EOT
    #     #!/bin/bash
    #     echo "ECS_CLUSTER=demo-nginx" >> /etc/ecs/ecs.config
    #     systemctl enable --now ecs
    #     EOT
    # )

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "ecs-ec2-instance"
        }
    }
}


resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = aws_subnet.public_subnets[*].id

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ecs-ec2-instance"
    propagate_at_launch = true
  }
}
