vpc_cidr            = "10.0.0.0/16"
az                  = ["ap-south-1a", "ap-south-1b"]

# image = "905418229997.dkr.ecr.ap-south-1.amazonaws.com/praveenraj:latest"
image = "nginx:latest"
img-name = "nginx-container"
task-count = 1
task-role = "arn:aws:iam::905418229997:role/ecsTaskExecutionRole"
img-id = "ami-0d06c73ba195c1c0c"
instance_type = "t3.micro"
# ecs-role = "arn:aws:iam::905418229997:role/ecsInstanceRole"
key = "june18"