provider "aws" {
  region = "ap-south-1"
}

variable "ami_id" {
  description = "value"
}

variable "instance_type" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.xlarge"
  }
}

variable "security_group" {
  description = "Select According to Workspaces"
  type = map(list(string))

  default = {
    "dev" = ["sg-07199e2284155c629"]
    "prod"= ["sg-0c52078289c14ed2c", "sg-0a4a0914049446c76"]
  }
}

module "ec2-instance" {
  source         = "./modules-ec2"
  ami_id         = var.ami_id
  instance_type  = lookup(var.instance_type, terraform.workspace, "t2.micro")
  security_group = lookup(var.security_group, terraform.workspace, ["sg-05bc0e725c9551878"])
}
