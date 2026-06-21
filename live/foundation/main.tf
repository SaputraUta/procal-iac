module "network" {
  source = "../../modules/network"

  name_prefix = "procal"
  vpc_cidr    = "10.0.0.0/16"
  azs         = ["ap-southeast-1a", "ap-southeast-1b"]
}

module "security" {
  source      = "../../modules/security"
  name_prefix = "procal"
  vpc_id      = module.network.vpc_id
}

module "rds" {
  source                 = "../../modules/rds"
  name_prefix            = "procal"
  subnet_ids             = module.network.private_subnet_ids
  vpc_security_group_ids = [module.security.rds_sg_id]
}

module "alb" {
  source            = "../../modules/alb"
  name_prefix       = "procal"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
}