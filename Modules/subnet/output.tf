output "prvsub1" {
    value = aws_subnet.lington-priv1.id 
}

output "prvsub2" {
    value = aws_subnet.lington-priv2.id 
}

output "pubsub1" {
  value = aws_subnet.lington-pub1.id
}

output "pubsub2" {
  value = aws_subnet.lington-pub2.id
}