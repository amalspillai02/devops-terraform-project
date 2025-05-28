provider "aws" {
  region = "ap-southeast-1"
}

module "network" {
  source = "./network"
}

module "compute" {
  source = "./compute"
  vpc_id             = module.network.vpc_id
  public_subnet_id   = module.network.public_subnet_id
}

module "s3" {
  source = "./s3"
}

module "database" {
  source            = "./database"
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  vpc_id            = module.network.vpc_id
  ec2_sg_id         = module.compute.ec2_sg_id
}