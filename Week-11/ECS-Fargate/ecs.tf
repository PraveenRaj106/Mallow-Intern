resource "aws_ecs_cluster" "demo_cluster" {
    name = "demo-nginx"
}

resource "aws_ecs_task_definition" "demo_task" {
    family                   = "demo-nginx"
    network_mode             = "awsvpc"
    requires_compatibilities  = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"
    task_role_arn            = var.task-role
    execution_role_arn       = var.task-role

    container_definitions = jsonencode([
        {
            name      = var.img-name
            image     = var.image   #dynamic port mapping
            cpu       = 256
            memory    = 512
            essential = true

            portMappings = [
                {
                    containerPort = 80
                    hostPort      = 80
                    protocol      = "tcp"
                }
            ]

            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group         = "/ecs/nginx"
                    awslogs-region        = "ap-south-1"
                    awslogs-stream-prefix = "ecs"
                }
            }
        }
    ])
}

resource "aws_ecs_service" "demo_service" {
    name            = "demo-nginx"
    cluster        = aws_ecs_cluster.demo_cluster.id
    task_definition = aws_ecs_task_definition.demo_task.id
    desired_count   = var.task-count
    launch_type     = "FARGATE"

    network_configuration {
        subnets          = aws_subnet.public_subnets[*].id
        security_groups  = [aws_security_group.ecs_sg.id]
        # assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.my_tg.arn
        container_name   = var.img-name
        container_port   = 80
    }
}
