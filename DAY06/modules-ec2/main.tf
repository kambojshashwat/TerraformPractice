provider "aws" {
  region = "ap-south-1"
}

variable "ami_id" {
  description = "This is the ubuntu AMI for the Instance.."
}

variable "instance_type" {
  description = "This is the Instance Type for Your VM"
}

variable "security_group" {
  description = "Enter the SG ID"
}

resource "aws_instance" "server1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group
}
