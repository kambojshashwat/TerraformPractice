provider "aws" {
  region = "ap-south-1"
}

module "ec2-instances" {
  source    = "./module/ec2-instance"
  ami_value = "ami-0e1d06225679bc1c5"
  instance_type_value = "t2.micro"
  subnet_value = "subnet-0b7a1885857138624"
  subnet_value2 = "subnet-0238d78f04b458b50"
}
