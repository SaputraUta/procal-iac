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
  certificate_arn   = module.dns.certificate_arn
}

module "compute" {
  source           = "../../modules/compute"
  name_prefix      = "procal"
  subnet_ids       = module.network.private_subnet_ids
  app_sg_id        = module.security.app_sg_id
  target_group_arn = module.alb.target_group_arn
}

module "sqs" {
  source      = "../../modules/sqs"
  name_prefix = "procal"
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "procal-apps-555431941608"
}

module "secrets" {
  source      = "../../modules/secrets"
  name_prefix = "procal"
}

module "dns" {
  source         = "../../modules/dns"
  public_domain  = "procal.saputra.dev"
  private_domain = "procal.internal"
  vpc_id         = module.network.vpc_id
}

resource "aws_route53_record" "app" {
  zone_id = module.dns.public_zone_id
  name    = "procal.saputra.dev"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

module "atlantis" {
  source             = "../../modules/tooling_service"
  name               = "atlantis"
  vpc_id             = module.network.vpc_id
  subnet_id          = module.network.tooling_subnet_ids[0]
  alb_sg_id          = module.security.alb_sg_id
  https_listener_arn = module.alb.https_listener_arn
  public_zone_id     = module.dns.public_zone_id
  alb_dns_name       = module.alb.alb_dns_name
  alb_zone_id        = module.alb.alb_zone_id
  hostname           = "atlantis.procal.saputra.dev"
  app_port           = 4141
  health_check_path  = "/healthz"
  listener_priority  = 100
  policy_arns        = ["arn:aws:iam::aws:policy/AdministratorAccess"]
} # test atlantis