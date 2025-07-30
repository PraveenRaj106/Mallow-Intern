output "public_subnet_id" {
  value = aws_subnet.my_public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.my_private_subnet.id
}