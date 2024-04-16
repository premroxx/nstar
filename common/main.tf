provider "aws" {
   region = var.primary_region
   alias  = "primary"
}

provider "aws" {
   region = var.secondary_region
   alias  = "secondary"
}

resource "aws_dynamodb_table" "primary" {
  provider = aws.primary

  hash_key         = var.dynamo_table_key
  name             = var.dynamo_table_name
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = var.dynamo_table_key
    type = var.dynamo_table_key_type
  }
}

resource "aws_dynamodb_table" "secondary" {
  provider = aws.secondary

  hash_key         = var.dynamo_table_key
  name             = var.dynamo_table_name
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 1
  write_capacity   = 1

  attribute {
    name = var.dynamo_table_key
    type = var.dynamo_table_key_type
  }
}

resource "aws_dynamodb_global_table" "myTable" {
  depends_on = [
    aws_dynamodb_table.primary,
    aws_dynamodb_table.secondary,
  ]
  provider = aws.primary

  name = var.dynamo_table_name

  replica {
    region_name = var.primary_region
  }

  replica {
    region_name = var.secondary_region
  }
}