
provider "aws" {
  #version = "=1.36"
  alias                   = "eu-west-1-jb"
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "jb-eu-west-1"
}