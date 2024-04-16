variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "secondary_region" {
  type    = string
  default = "us-east-2"
}

#Dynamodb
variable "dynamo_table_name" {
  type = string
}

variable "dynamo_table_key" {
  type = string
}

variable "dynamo_table_key_type" {
  type    = string
  default = "S"
}