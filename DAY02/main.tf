resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
    tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "asso1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "asso2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  vpc_id      = aws_vpc.myvpc.id
 
  ingress {
    description = "HTTP from ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  vpc_id      = aws_vpc.myvpc.id
 
  ingress {
    description = "Traffic from ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
    ingress {
    description = "Traffic for SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2-sg"
  }
}

#resource "aws_s3_bucket" "mybuck" {
#  bucket = "mybuck170623"
#}

resource "aws_instance" "server1" {
  ami = var.ubunami
  instance_type = "t2.micro"
  key_name = "aws-key"
  subnet_id = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = base64encode(file("userdata.sh"))
  tags = {
    Name = "Server1"
  }
}

resource "aws_instance" "server2" {
  ami = var.ubunami
  instance_type = "t2.micro"
  key_name = "aws-key"
  subnet_id = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    user_data = base64encode(file("userdata.sh"))
  tags = {
    Name = "Server2"
  }
}

resource "aws_lb_target_group" "TG" {
  name = "MyTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id = aws_instance.server1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id = aws_instance.server2.id
  port = 80
}

resource "aws_lb" "alb" {
  name = "myalb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]
    
  tags = {
    Name = "MyALB"
  }
}

resource "aws_lb_listener" "mylistner" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.TG.arn
    type = "forward"
  }
}

output "alb_dns" {
  value = aws_lb.alb.dns_name  
}
