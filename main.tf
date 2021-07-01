provider "aws" {
  access_key = "AKIATGYKIOIEYVK3JY3H"
  secret_key = "p2Lfh8lZjo5mveEGeBg9ZZbyC+36/KTY3vfA6/so"
  region     = "us-east-1"
}

module "sample_module" {
  source      = "/tmp/modules"
}




