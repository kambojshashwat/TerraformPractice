provider "aws" {
    region = "ap-south-1"  #In which region you want to create EC2
}

resource "aws_instance" "example" {
  ami                     = "ami-0e1d06225679bc1c5"   #modify according to your ami
  instance_type           = "t2.micro"
  key_name                = "aws-key"                 #select your key-pair
  vpc_security_group_ids  = ["sg-07199e2284155c629"]
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "Terraform_EC2"
  }
}
