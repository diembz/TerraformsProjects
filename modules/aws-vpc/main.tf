provider "aws" {                       # Configuración del proveedor AWS.
  region = var.vpcconfig.vpc[0].region # La región se obtiene de la primera configuración en la lista vpcconfig.vpc
}

data "aws_region" "current" {} # Data source que obtiene la información de la región actual en AWS

resource "aws_vpc" "mi_die_vpc" { # Crear una VPC y asignar direcciones IP desde el pool del IPAM.
  for_each = { for entry in var.vpcconfig.vpc : entry.vpc_name => entry }
  cidr_block = each.value.cidr_block
  ipv6_cidr_block = each.value.ipv6_cidr_block
  ipv6_ipam_pool_id = each.value.ipv6_ipam_pool_id
  ipv6_netmask_length = each.value.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = each.value.ipv6_cidr_block_network_border_group
  ipv4_ipam_pool_id   = each.value.ipv4_ipam_pool_id
  ipv4_netmask_length = each.value.ipv4_netmask_length

  enable_network_address_usage_metrics = each.value.enable_network_address_usage_metrics
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  instance_tenancy     = each.value.instance_tenancy

  assign_generated_ipv6_cidr_block = each.value.assign_generated_ipv6_cidr_block

  tags = each.value.tags

}
resource "aws_subnet" "mi_die_subnet" { # Crear múltiples subnets, una por cada Availability Zone, asignándoles bloques CIDR desde el IPAM y etiquetándolas.
  count             = length(var.vpcconfig.vpc[0].availability_zones)
  vpc_id            = aws_vpc.mi_die_vpc[].id
  cidr_block        = cidrsubnet(aws_vpc_ipam_pool_cidr.test.cidr, 8, count.index)
  availability_zone = var.vpcconfig.vpc[0].availability_zones[count.index]

  tags = {
    Name = format("Subnet-%s", count.index)
  }
}

resource "aws_route_table" "die_route_table" { # Crear una tabla de rutas para controlar el enrutamiento del tráfico en la VPC y asignarle un nombre.
  vpc_id = aws_vpc.mi_die_vpc.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "mi_route_table_assoc" { # # Asocia cada subnet con la tabla de rutas para definir cómo se enruta el tráfico dentro de cada subnet.
  count          = length(aws_subnet.mi_die_subnet)
  subnet_id      = aws_subnet.mi_die_subnet[count.index].id
  route_table_id = aws_route_table.die_route_table.id}

