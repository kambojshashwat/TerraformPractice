provider "aws" {
}

resource "aws_instance" "server1" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = var.subnet_value
  vpc_security_group_ids = ["sg-07199e2284155c629"]
  key_name               = "aws-key"

  tags = {
    Name = "Server1"
  }
}

resource "aws_instance" "server2" {
  ami                    = var.ami_value
  instance_type          = var.instance_type_value
  subnet_id              = var.subnet_value2
  vpc_security_group_ids = ["sg-07199e2284155c629", "sg-0c52078289c14ed2c"]
  key_name               = "aws-key"

  tags = {
    Name = "Server2"
  }
}
