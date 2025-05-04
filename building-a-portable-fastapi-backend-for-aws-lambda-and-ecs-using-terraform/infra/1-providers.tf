data "aws_ecr_authorization_token" "token" {}

provider "aws" {
  region = "eu-west-1"
}

provider "docker" {
  registry_auth {
    address  = "668605713641.dkr.ecr.eu-west-1.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
