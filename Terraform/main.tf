# main.tf

provider "aws" {
  region = "eu-west-1"  # specify your desired AWS region
}

resource "random_pet" "bucket_suffix" {
  length    = 10  # specify the length of the random string
  separator = "-"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "Cardalog-pictures-${random_pet.bucket_suffix.id}"  # specify a globally unique bucket name

  acl    = "private"  # Access Control List for the bucket, you can change it as needed

  versioning {
    enabled = false  # enable versioning for the bucket
  }

  tags = {
    Name        = "CardBucket"
    Environment = "Development"
  }
}