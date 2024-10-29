output "vpc_ids" {
  value = { for name, vpc in aws_vpc.mi_die_vpc : name => vpc.id }
}


output "subnet_ids" {
  value = { for name, subnet in aws_subnet.mi_die_subnet : name => subnet.id }
}


