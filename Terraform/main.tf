# main.tf

provider "aws" {
  region = "eu-north-1"  # specify your desired AWS region
}

resource "random_pet" "bucket_suffix" {
  length    = 3  # specify the length of the random string
  separator = "-"
}

resource "aws_s3_bucket_acl" "cardalog-picture-bucket" {
  bucket = "cardalog-pictures-${random_pet.bucket_suffix.id}"

  acl    = "private"
}

resource "aws_s3_bucket_acl" "cardalog-tfstate-bucket" {
  bucket = "cardalog-tfstate-${random_pet.bucket_suffix.id}"

  acl    = "private"
}