provider "aws" {
  region = "ap-south-1"
}

#module "ec2-instances" {
#  source    = "./module/ec2-instance"
#  ami_value = "ami-0e1d06225679bc1c5"
#  instance_type_value = "t2.micro"
#  subnet_value = "subnet-0b7a1885857138624"
#  subnet_value2 = "subnet-0238d78f04b458b50"
#}

module "vpc-create" {
  source = "./module/vpc"
  myvpc = "10.0.0.0/16"
  pubsub1 = "10.0.0.0/24"
  pubsub2 = "10.0.1.0/24"
  availability_zone_for_pubsub1 = "ap-south-1a"
  availability_zone_for_pubsub2 = "ap-south-1b"
  prisub1 = "10.0.2.0/24"
}
