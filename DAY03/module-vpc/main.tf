provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc1" {
  cidr_block = var.myvpc
  tags = {
    Name = "NewVpc"
  }
}

resource "aws_subnet" "publicsub1" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = var.pubsub1
  availability_zone       = var.availability_zone_for_pubsub1
  map_public_ip_on_launch = true

  tags = {
    Name = "PubSub1"
  }
}

resource "aws_subnet" "publicsub2" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = var.pubsub2
  availability_zone       = var.availability_zone_for_pubsub2
  map_public_ip_on_launch = true

  tags = {
    Name = "PubSub2"
  }
}

resource "aws_subnet" "privatesub1" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = var.prisub1
  availability_zone       = var.availability_zone_for_pubsub2

  tags = {
    Name = "PriSub1"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.myvpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "MyPubRT"
  }
}

resource "aws_route_table" "priRT" {
  vpc_id = aws_vpc.myvpc1.id
  tags = {
    Name = "MyPrivateRT"
  }
}

resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.priRT.id
  subnet_id = aws_subnet.privatesub1.id
}

resource "aws_route_table_association" "associate1" {
  route_table_id = aws_route_table.pubRT.id
  subnet_id      = aws_subnet.publicsub1.id
}

resource "aws_route_table_association" "associate2" {
  route_table_id = aws_route_table.pubRT.id
  subnet_id      = aws_subnet.publicsub2.id
}
