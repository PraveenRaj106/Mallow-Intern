vpc_cidr            = "10.0.0.0/16"
az                  = ["ap-south-1a", "ap-south-1b"]



instance_class      = "db.t3.micro"
engine              = "postgres"
engine_version      = "13.21" 
port                = 5432
storage             = 20
multi_az            = true
skip_final_snapshot = true
username            = "myadmin"
password            = "Joy030317!"
