provider "aws" {
  access_key = "enter here"
  secret_key = "enter here"
  region     = "us-east-1"
}

module "sample_module" {
  source      = "/tmp/modules"
}




