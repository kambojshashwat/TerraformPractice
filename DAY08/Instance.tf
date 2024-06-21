# Define the AWS EC2 instance resource
resource "aws_instance" "EC2" {
  instance_type = "t2.micro"
  ami = "ami-0e1d06225679bc1c5"
  key_name = "aws-key"
  subnet_id = aws_subnet.pubsub1.id

  tags = {
    Name = "InstanceServer"
  }
}

# Define the AWS AMI from instance resource
resource "aws_ami_from_instance" "AMI-EC2" {
  source_instance_id = aws_instance.EC2.id
  name = "AMI-EC2"
}

# Define a local-exec provisioner to execute a shell command after resource creation
resource "null_resource" "terminate_instance" {
  # This resource depends on the creation of the AMI
  depends_on = [aws_ami_from_instance.AMI-EC2]

  # Execute a local shell command to terminate the EC2 instance
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.EC2.id}"
  }
}
