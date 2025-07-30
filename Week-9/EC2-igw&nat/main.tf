module "VPC" {
  source = "./VPC"
}

module "EC2" {
  source = "./EC2"
  public_subnet_id  = module.VPC.public_subnet_id
  private_subnet_id = module.VPC.private_subnet_id
}