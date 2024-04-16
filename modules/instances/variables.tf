variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EC2 instance will be deployed."
}

variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet where the EC2 instance will be deployed."
}

variable "ami" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instance."
}

# variable "key_name" {
#   type        = string
#   description = "The name of the EC2 key pair used for SSH access."
# }

variable "instance_type" {
  type        = string
  default     = "t2.medium"
  description = "The type of EC2 instance to launch."
}


##asg
variable "key_name" {
  default = "virginia"
}

# variable "instance_type" {
#   default = "t2.micro"
# }

variable "instance_name" {
  default = "Web Server of Phonebook App"
}

variable "aws_launch_template_name" {
  default = "phonebook-lt"
}

variable "load_balancer_target_group_name" {
  default = "phonebook-lb-tg"
}

variable "load_balancer_name" {
  default = "phonebook-lb-tf"
}

variable "aws_autoscaling_group_name" {
  default = "phonebook-asg"
}