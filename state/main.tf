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
   bucket = "nstar-tfstate-sandbox-east1"
   dynamodb = "terraform_locks_us-east-1"
   region = "us-east-1"
}

module "state-usw2" {
   source = "./module"
   bucket = "nstar-tfstate-sandboxwest2"
   dynamodb = "terraform_locks_us-west-2"
   region = "us-west-2"
}

module "state-common" {
   source = "./module"
   bucket = "nstar-tfstate-sandbox-common"
   dynamodb = "terraform_locks_common"
   region = "us-east-1"
}