# module "networks" {
#   source    = "../modules/networks"
#   region    = var.region
#   ec2_sg_id = module.instances.ec2_sg_id
#   az        = var.az
# }

# module "s3" {
#   source = "../modules/s3"
#   bucket = var.bucket
# }

# # module "dynamodb" {
# #   source                = "../modules/dynamodb"
# #   dynamo_table_name     = var.dynamo_table_name
# #   dynamo_table_key      = var.dynamo_table_key
# #   dynamo_table_key_type = var.dynamo_table_key_type
# # }

# module "instances" {
#   source           = "../modules/instances"
#   vpc_id           = module.networks.vpc_id
#   public_subnet_id = module.networks.public_subnet_id
#   ami              = var.ami
#   key_name         = var.key_name
#   #depends_on       = [module.dynamodb]
# }

# data "aws_route53_zone" "default" {
#   name = var.r53_zone_name
# }

# resource "aws_route53_record" "cdnv4" {
#   zone_id = data.aws_route53_zone.default.zone_id
#   name = format(
#     "%s.%s",
#     var.r53_domain_name,
#     data.aws_route53_zone.default.name,
#   )
#   type           = "A"
#   ttl            = "60"
#   records        = module.instances.public_ip
#   set_identifier = "cdn-${var.region}-v4"

#   latency_routing_policy {
#     region = var.region
#   }
# }


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myvpc-${var.region}"
  cidr = "10.200.0.0/16"

  azs              = ["us-west-2a", "us-west-2b"]
  private_subnets  = ["10.200.1.0/24", "10.200.2.0/24"]
  public_subnets   = ["10.200.101.0/24", "10.200.102.0/24"]
  database_subnets = ["10.200.201.0/24", "10.200.202.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "alb" {
  source           = "../modules/alb"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets
}

module "ecs" {
  source                  = "../modules/ecs"
  vpc_id                  = module.vpc.vpc_id
  alb_sg_id               = module.alb.lb_sg_id
  aws_alb_target_group_id = module.alb.aws_alb_target_group_id
  public_subnet_ids       = module.vpc.public_subnets
  depends_on              = [module.alb]
}