provider "aws" {
   region = "us-east-1"
   alias  = "primary"
}

provider "aws" {
   region = "us-west-2"
   alias  = "secondary"
}

module "state-use1" {
   source = "./module"
   bucket = "nstar-tfstate-east1"
   dynamodb = "terraform_locks_us-east-1"
   region = "us-east-1"
}

module "state-usw2" {
   source = "./module"
   bucket = "nstar-tfstate-west2"
   dynamodb = "terraform_locks_us-west-2"
   region = "us-west-2"
}
