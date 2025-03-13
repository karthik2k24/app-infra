provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source = "./vpc"
}

module "eks" {
  source = "./eks"
  vpc_id = module.vpc.vpc_id
  pvt_app_1b_id = module.vpc.pvt_app_1b_id
  pvt_app_1c_id = module.vpc.pvt_app_1c_id

}