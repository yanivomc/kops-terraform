### jb account

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "jb-cloud-terraform-vpc-remote-state"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-west-1"
    key            = "terraform.tfstate"
    workspace_key_prefix = "jb-cloud-infra-k8s"
  }
}



### ROOT ACCOUNT

# terraform {
#   backend "s3" {
#     encrypt        = true
#     #bucket         = "jb-cloud-terraform-vpc-remote-state"
#     bucket         = "root-cloud-terraform-vpc-remote-state"
#     dynamodb_table = "terraform-state-lock-dynamo"
#     region         = "eu-west-1"
#     key            = "terraform.tfstate"
#     workspace_key_prefix = "jb-cloud-infra-k8s"
#   }
# }

