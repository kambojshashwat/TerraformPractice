resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "pubsub1" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Sub 1"
  }
}

resource "aws_subnet" "pubsub2" {
  vpc_id = aws_vpc.myvpc.id
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Sub 2"
  }
}

resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "MyVPCIGW"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    gateway_id = aws_internet_gateway.MyIGW.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "Sub1Associate" {
  subnet_id = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "Sub2Associate" {
  subnet_id = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "newSG" {
  name = "MySG"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from Anywhere"
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH From Anywhere"
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
