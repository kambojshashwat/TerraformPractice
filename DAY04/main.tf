provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server1" {
  ami           = "ami-0e1d06225679bc1c5"
  instance_type = "t2.micro"
  key_name = "aws-key"
}

/*resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}*/
