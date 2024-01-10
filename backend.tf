terraform {
  backend "s3" {
    bucket = "backend-test123-bucket"
    key    = "sample-backend/terraform.tfstate"
    dynamodb_table = "sample-dynamodb-state-lock-terraform"
    region = "us-east-1"
  }
}
