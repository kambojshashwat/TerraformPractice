output "value_of_public_ip1" {
  value = aws_instance.server1.public_ip
}
output "value_of_public_ip2" {
  value = aws_instance.server2.public_ip
}
