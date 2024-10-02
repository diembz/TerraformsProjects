module "ec2-s3" {
  source       = "./modules/aws-ec2-s3"
  moduleconfig = var.moduleconfig
}
