vpc_cidr            = "10.0.0.0/16"
az                  = ["ap-south-1a", "ap-south-1b"]

# image = "905418229997.dkr.ecr.ap-south-1.amazonaws.com/praveenraj:latest"
image = "nginx:latest"
img-name = "nginx-container"
task-count = 2
task-role = "arn:aws:iam::905418229997:role/ecsTaskExecutionRole"