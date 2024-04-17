terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nstar-tfstate-sandbox-common"
    region         = "us-east-1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform_locks_common"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
