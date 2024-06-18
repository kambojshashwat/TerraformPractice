terraform {
  backend "s3" {
    bucket = "mys311june"
    key    = "secret/terraform.tfstate"
    region = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
