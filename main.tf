provider "aws" {
  region = "us-east-1"
}

#Not required as we can connect to pvt pod directly using kubectl exec -it <pod-name> -- /bin/bash
# module "bastion" {
#   source = "./bastion"
#   vpc_id        = module.vpc.vpc_id
#   pub_app_1a_id = module.vpc.pub_app_1a_id
# }

module "vpc" {
  source = "./vpc"
}

module "eks" {
  source        = "./eks"
  vpc_id        = module.vpc.vpc_id
  pvt_app_1a_id = module.vpc.pvt_app_1a_id
  # pvt_app_1b_id = module.vpc.pvt_app_1b_id

}