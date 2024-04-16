module "common" {
   source = "./common"
   dynamo_table_name     = var.dynamo_table_name
   dynamo_table_key      = var.dynamo_table_key
   dynamo_table_key_type = var.dynamo_table_key_type
}