resource "aws_launch_template" "server-temp" {
  name = "server-temp"
  image_id = aws_ami_from_instance.AMI-EC2.id
  instance_type = "t2.micro"
  key_name = "aws-key"
  vpc_security_group_ids = [aws_security_group.newSG.id]
  
    user_data = base64encode(file("userdata.sh"))
  
  lifecycle {
    create_before_destroy = true
  }
}
