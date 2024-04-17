variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EC2 instance will be deployed."
}

variable "public_subnet_id" {
  type        = list(string)
  description = "The ID of the public subnet where the EC2 instance will be deployed."
}