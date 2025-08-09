
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  # default     = "10.0.0.0/16"
}

variable "az" {
  type        = list(string)
  description = "Availability Zones"
  # default     = ["ap-south-1a", "ap-south-1b"]
}

variable "identifier" {
  type        = string
  description = "Identifier for the RDS instance"
  default     = "my-rds-instance"
}

variable "instance_class" {
  type = string
  description = "Instance type for the RDS instance"
  # default = "db.t3.micro"
}

variable "engine" {
  type        = string
  description = "Database engine for the RDS instance"
  # default     = "postgres"
}

variable "engine_version" {
  type        = string
  description = "Version of the database engine"
  # default     = "13.21"
}

variable "port" {
  type        = number
  description = "Port for the RDS instance"
  # default     = 5432
}

variable "storage" {
  type = number
  description = "Storage size for the RDS instance (in GB)"
  # default = 20
}

variable "db_name" {
  type        = string
  description = "Name of the database"
  default     = "demodb"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ for the RDS instance"
  # default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip final snapshot before deleting the RDS instance"
  # default     = false
}

variable "username" {
  type        = string
  description = "Username for the database"
}

variable "password" {
  type        = string
  description = "Password for the database"
  sensitive   = true
}