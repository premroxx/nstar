terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nstar-tfstate-sandbox-east1"
    region         = "us-east-1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform_locks_us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
