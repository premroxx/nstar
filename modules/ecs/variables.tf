variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EC2 instance will be deployed."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "The ID of the VPC where the EC2 instance will be deployed."
}

variable "alb_sg_id" {
  type        = string
}

variable "aws_alb_target_group_id" {
  type = string
}