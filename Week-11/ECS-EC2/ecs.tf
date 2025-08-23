resource "aws_ecs_cluster" "demo_cluster" {
    name = var.ecs-name
}

resource "aws_ecs_task_definition" "demo_task" {
    family                   = "demo-nginx"
    network_mode             = "bridge"
    requires_compatibilities  = ["EC2"]
    cpu                      = "256"
    memory                   = "256"
    task_role_arn            = var.task-role
    execution_role_arn       = var.task-role

    container_definitions = jsonencode([
        {
            name      = var.img-name
            image     = var.image   #dynamic port mapping
            cpu       = 256
            memory    = 256
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
    cluster         = aws_ecs_cluster.demo_cluster.id
    task_definition = aws_ecs_task_definition.demo_task.id
    desired_count   = var.task-count
    launch_type     = "EC2"

    # network_configuration {
    #     subnets          = aws_subnet.public_subnets[*].id
    #     security_groups  = [aws_security_group.ecs_sg.id]
    #     assign_public_ip = true
    # }

    load_balancer {
        target_group_arn = aws_lb_target_group.my_tg.arn
        container_name   = var.img-name
        container_port   = 80
    }
}


resource "aws_ecs_capacity_provider" "ecs_cp" {
  name = "asg-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
    }
  }
}

#####################################
# Associate Capacity Provider with Cluster
#####################################
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_cp" {
  cluster_name       = aws_ecs_cluster.demo_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
    weight            = 1
    base              = 1
  }
}