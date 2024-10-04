output "vpc_id" {
  value = aws_vpc.mi_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.mi_subnet[*].id
}
