#Para la VPC

resource "aws_vpc" "mi_die_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

#Subnets

resource "aws_subnet" "mi_die_subnet" {
  count             = length(var.subnet_cidrs) # Esto nos permite crear tantas subnets como CIDRs definamos
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = format("Subnet-%s", count.index)
  }
}

# count: Esta línea le está diciendo a Terraform: "Crea tantas subnets como la cantidad de CIDRs que haya en subnet_cidrs"
# cidr_block = var.subnet_cidrs[count.index] // Aquí, por cada subnet que se crea, estás asignándole un CIDR específico de la lista subnet_cidrs. El count.index es el índice de cada iteración, Si tienes 3 CIDRs, el count.index será 0, 1, 2 en cada iteración y así Terraform le asigna a cada subnet un CIDR diferente de la lista.
# Le da un nombre único a cada subnet que se cree. En este caso, el nombre será Subnet-0, Subnet-1, Subnet-2, etc. dependiendo del índice del count.



#Route tables

resource "aws_route_table" "die_route_table" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "mi_route_table_assoc" {
  count          = length(aws_subnet.mi_subnet)
  subnet_id      = aws_subnet.mi_subnet[count.index].id
  route_table_id = aws_route_table.mi_route_table.id
}

