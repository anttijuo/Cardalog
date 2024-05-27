# main.tf

provider "aws" {
  region = "eu-north-1"  # specify your desired AWS region
}

resource "random_pet" "bucket_suffix" {
  length    = 3  # specify the length of the random string
  separator = "-"
}

resource "aws_s3_bucket" "cardalog-picture-bucket" {
  bucket = "cardalog-pictures-${random_pet.bucket_suffix.id}"  # specify a globally unique bucket name

  acl    = "private"  # Access Control List for the bucket, you can change it as needed

  tags = {
    Name        = "CardBucket"
    Environment = "Development"
  }
}

resource "aws_s3_bucket" "cardalog-tfstate-bucket" {
  bucket = "cardalog-tfstate-${random_pet.bucket_suffix.id}"  # specify a globally unique bucket name

  acl    = "private"  # Access Control List for the bucket, you can change it as needed

  tags = {
    Name        = "TfstateBucket"
    Environment = "Development"
  }
}

terraform {
  backend "s3" {
    # NOTE that the bucket name below needs to be hard-coded
    # Change name to match your personally generated name from cardalog-tfstate-${random_pet.bucket_suffix.id} above
    bucket         = "cardalog-tfstate-lately-saved-krill"
    key            = "terraform/state/terraform.tfstate"
    region         = "eu-north-1"
    #dynamodb_table = "your-dynamodb-table-name"
    encrypt        = true
  }
}