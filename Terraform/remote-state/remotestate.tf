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