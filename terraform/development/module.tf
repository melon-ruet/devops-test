locals {
  aws_profile = "your-profile"
}

provider "aws" {
  profile = local.aws_profile
}

module "dev" {
  source      = "../"
  aws_profile = local.aws_profile
  prefix      = "dev"
  db_user     = "foo"
  db_password = "foobar007"
}