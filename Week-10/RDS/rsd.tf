resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "my-DB-Subnet-Group"
  }
}

resource "aws_db_instance" "my_rds" {
    identifier             = var.identifier
    engine                 = var.engine
    engine_version         = var.engine_version
    instance_class         = var.instance_class
    allocated_storage      = var.storage
    db_name                = var.db_name
    username               = var.username
    password               = var.password
    multi_az               = var.multi_az
    skip_final_snapshot    = var.skip_final_snapshot
    db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.my_db_sg.id]
    port                   = var.port
    tags = {
        Name = "my-rds"
    }
}
