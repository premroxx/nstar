module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myvpc-${var.region}"
  cidr = "10.100.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.100.1.0/24", "10.100.2.0/24"]
  public_subnets  = ["10.100.10.0/24", "10.100.10.0/24"]
  database_subnets    = ["10.100.20.0/24", "10.100.21.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# resource "aws_vpc" "vpc" {
#   cidr_block           = "10.100.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "vpc"
#   }
# }

# resource "aws_subnet" "public_subnet1" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.100.1.0/24"
#   availability_zone = var.az

#   tags = {
#     Name = "public_subnet"
#   }
# }

# resource "aws_subnet" "public_subnet2" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.100.2.0/24"
#   availability_zone = var.az

#   tags = {
#     Name = "public_subnet"
#   }
# }


# resource "aws_subnet" "private_subnet1" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.100.3.0/24"
#   availability_zone = var.az

#   tags = {
#     Name = "private_subnet"
#   }
# }

# resource "aws_subnet" "private_subnet2" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.100.4.0/24"
#   availability_zone = var.az

#   tags = {
#     Name = "private_subnet"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "igw"
#   }
# }

# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "public_route_table"
#   }
# }

# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.public_subnet1.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.public_subnet2.id
#   route_table_id = aws_route_table.public_route_table.id
# }


# resource "aws_vpc_endpoint" "s3_endpoint" {
#   vpc_id          = aws_vpc.vpc.id
#   service_name    = "com.amazonaws.${var.region}.s3"
#   route_table_ids = [aws_route_table.public_route_table.id]
# }

# resource "aws_vpc_endpoint" "dynamodb_endpoint" {
#   vpc_id          = aws_vpc.vpc.id
#   service_name    = "com.amazonaws.${var.region}.dynamodb"
#   route_table_ids = [aws_route_table.public_route_table.id]
# }

# resource "aws_vpc_endpoint" "ec2" {
#   vpc_id              = aws_vpc.vpc.id
#   service_name        = "com.amazonaws.${var.region}.ec2"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [var.ec2_sg_id]
#   private_dns_enabled = true
# }
