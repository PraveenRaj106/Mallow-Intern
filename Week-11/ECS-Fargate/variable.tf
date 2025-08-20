variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "image" {
  description = "Docker image for the ECS task"
  type        = string
  default     = "nginx:latest"
}

variable "img-name" {
  description = "Name of the container in the ECS task"
  type        = string
  default     = "nginx-container"
}

variable "task-count" {
  description = "Number of tasks to run"
  type        = number
  default     = 2
}

variable "task-role" {
  description = "IAM role for the ECS task"
  type        = string
}
