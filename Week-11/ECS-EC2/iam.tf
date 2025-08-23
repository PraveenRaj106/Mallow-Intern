# Create Instance Profile for existing role
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = "ecsInstanceRole"   # <-- use your existing role name
}

