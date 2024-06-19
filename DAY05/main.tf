provider "aws" {
  region = "ap-south-1"
}

variable "aws_vpc1" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "myvpc1" {
  cidr_block = var.aws_vpc1
  tags = {
    Name = "MyVPC1"
  }
}

resource "aws_subnet" "pubsub1" {
  vpc_id = aws_vpc.myvpc1.id
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "MyPubSub1"
  }
}

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "MYIGW"
  }
}

resource "aws_route_table" "PubRT" {
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "Public RT"
  }
  route {
    gateway_id = aws_internet_gateway.myIGW.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "Assoc1" {
  subnet_id = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.PubRT.id
}

resource "aws_security_group" "NewSG" {
  name = "NewSG"
  vpc_id = aws_vpc.myvpc1.id

  ingress{
    description = "SSH Allow"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress{
    description = "HTTP Allow"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "HTTP & SSH Allowed SG"
  }
}

resource "aws_key_pair" "keyterra" {
  key_name = "terraform-key"
  public_key = file("C:/Users/shash/.ssh/id_rsa.pub")
}

resource "aws_instance" "server1" {
  ami = "ami-0f58b397bc5c1f2e8"
  subnet_id = aws_subnet.pubsub1.id
  key_name = aws_key_pair.keyterra.key_name
  vpc_security_group_ids = [aws_security_group.NewSG.id]
  instance_type = "t2.micro"  

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/shash/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source = "app.py"
    destination = "/home/ubuntu/app.py"
  }
  provisioner "remote-exec" {
    inline = [
    "echo 'Hello from the remote instance'",
    "sudo apt update -y",  # Update package lists (for ubuntu)
    "sudo apt-get install -y python3-pip",  # Example package installation
    "cd /home/ubuntu",
    "sudo apt install python3-flask -y",
    "sudo systemctl daemon-reload",
    "sudo python3 app.py &",
    ]
  }
}

