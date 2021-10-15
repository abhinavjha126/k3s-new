terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.56.0"
    }
  }

}

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile = "testing"
  region  = var.aws_region
}
