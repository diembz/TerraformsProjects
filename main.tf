/*
module "ec2-s3" {
  source       = "./modules/aws-ec2-s3"
  moduleconfig = var.moduleconfig
}
*/
module "aws-vpc" {
  source    = "./modules/aws-vpc"
  vpcconfig = var.vpcconfig
}




