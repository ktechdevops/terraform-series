provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# terraform {
#     backend "s3" {
#         profile = "dfmlab"
#         key = "state/terraform.tfstate"
#         bucket = "xenv-poc-infra-state"
#         region = "us-east-1"
#         dynamodb_table = "terraform-locks"
#         encrypt = true
#         workspace_key_prefix = "xenv-poc"
#     }
# }
