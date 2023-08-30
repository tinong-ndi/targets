##Create VPC
module "vpc" {
  source       = "../../vercara-module/vpc"
  project-name = var.project-name
  vpc_cidr     = var.vpc_cidr
}

##Create SGS
module "sg" {
  source = "../../vercara-module/sg"
  vpc-id = module.vpc.vpc-id.id
}


module "alb" {
  source             = "../../vercara-module/alb"
  project-name       = module.vpc.project-name
  public-subnets-ids = module.vpc.public-subnets-ids[*]
  vpc-id             = module.vpc.vpc-id.id
  alb-sg-id          = module.sg.alb-sg-id
}

##No tags at this point

