output "vpc_id" {
  value = aws_vpc.mi_die_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.mi_die_subnet[*].id
}

