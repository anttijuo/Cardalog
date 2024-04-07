# dynamo.tf

provider "aws" {
  region = "eu-north-1"
  alias = "dynamo"
}

#resource "random_pet" "dynamo_suffix" {
#  length    = 2  # specify the length of the random string
#  separator = "-"
#}

resource "aws_dynamodb_table" "cardalog_card_data" {
  #name           = "cardalog-card-data-${random_pet.dynamo_suffix.id}"
  name           = "cardalog-card-data"
  billing_mode   = "PROVISIONED"  # or "PAY_PER_REQUEST" for on-demand billing
  read_capacity  = 5               # Adjust according to your read/write needs
  write_capacity = 5
  hash_key       = "primaryKeyCardalog"

  attribute {
    name = "primaryKeyCardalog"
    type = "S"  # S for string, N for number, B for binary
  }

  # Add additional attributes if needed
  #attribute {
  #  name = "cardName"
  #  type = "S"
  #}

  # Add global secondary indexes if needed
  # global_secondary_index {
  #   name               = "exampleGSI"
  #   hash_key           = "exampleGSIHashKey"
  #   range_key          = "exampleGSIRangeKey"
  #   read_capacity      = 5
  #   write_capacity     = 5
  #   projection_type    = "ALL"  # or "KEYS_ONLY" or "INCLUDE" with non-key attributes
  # }

  tags = {
   Name        = "cardalog-card-data"
   Environment = "development"
  }
}