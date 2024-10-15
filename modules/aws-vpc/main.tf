provider "aws" {                       # Configuración del proveedor AWS.
  region = var.vpcconfig.vpc[0].region # La región se obtiene de la primera configuración en la lista vpcconfig.vpc
}

data "aws_region" "current" {} # Data source que obtiene la información de la región actual en AWS

resource "aws_vpc" "mi_die_vpc" {
  for_each                             = { for entry in var.vpcconfig.vpc : entry.vpc_name => entry }
  cidr_block                           = each.value.cidr_block
  ipv6_cidr_block                      = each.value.ipv6_cidr_block
  ipv6_ipam_pool_id                    = each.value.ipv6_ipam_pool_id
  ipv6_netmask_length                  = each.value.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = each.value.ipv6_cidr_block_network_border_group
  ipv4_ipam_pool_id                    = each.value.ipv4_ipam_pool_id
  ipv4_netmask_length                  = each.value.ipv4_netmask_length

  enable_network_address_usage_metrics = each.value.enable_network_address_usage_metrics
  enable_dns_support                   = each.value.enable_dns_support
  enable_dns_hostnames                 = each.value.enable_dns_hostnames
  instance_tenancy                     = each.value.instance_tenancy

  assign_generated_ipv6_cidr_block = each.value.assign_generated_ipv6_cidr_block

  tags = each.value.tags

}

resource "aws_subnet" "mi_die_subnet" { # Crear múltiples subnets, una por cada Availability Zone, asignándoles bloques CIDR desde el IPAM y etiquetándolas.
  for_each          = { for entry in var.vpcconfig.subnets : entry.subnet_name => entry }
  vpc_id            = aws_vpc.mi_die_vpc[vpc_name].id
  cidr_block        = cidrsubnet(aws_vpc_ipam_pool_cidr.test.cidr, 8, count.index)
  availability_zone = var.vpcconfig.vpc[0].availability_zones[count.index]

  assign_ipv6_address_on_creation                = ""
  availability_zone_id                           = ""
  customer_owned_ipv4_pool                       = ""
  enable_dns64                                   = "false"
  enable_lni_at_device_index                     = ""
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  enable_resource_name_dns_a_record_on_launch    = ""
  ipv6_cidr_block                                = ""
  ipv6_native                                    = "false"
  map_customer_owned_ip_on_launch                = "false"
  map_public_ip_on_launch                        = ""
  outpost_arn                                    = ""
  private_dns_hostname_type_on_launch            = ""

  tags = {
    Name = format("Subnet-%s", count.index)
  }
}

resource "aws_route_table" "die_route_table" { # Crear una tabla de rutas para controlar el enrutamiento del tráfico en la VPC y asignarle un nombre.
  for_each = 
  vpc_id            = aws_vpc.mi_die_vpc[vpc_name].id
  propagating_vgws = each.value.propagating_vgws # Opcional: Virtual gateways para propagación

  route {
    cidr_block                 = each.value.route.cidr_block
    ipv6_cidr_block            = each.value.route.ipv6_cidr_block
    destination_prefix_list_id = each.value.route.destination_prefix_list_id
    carrier_gateway_id         = each.value.route.carrier_gateway_id
    core_network_arn           = each.value.route.core_network_arn
    egress_only_gateway_id     = each.value.route.egress_only_gateway_id
    gateway_id                 = each.value.route.gateway_id
    local_gateway_id           = each.value.route.local_gateway_id
    nat_gateway_id             = each.value.route.nat_gateway_id
    network_interface_id       = each.value.route.network_interface_id
    transit_gateway_id         = each.value.route.transit_gateway_id
    vpc_endpoint_id            = each.value.route.vpc_endpoint_id
    vpc_peering_connection_id  = each.value.route.vpc_peering_connection_id
  }

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "mi_route_table_assoc" { # # Asocia cada subnet con la tabla de rutas para definir cómo se enruta el tráfico dentro de cada subnet.
  for for_each = 
  count          = length(aws_subnet.mi_die_subnet)
  subnet_id      = aws_subnet.mi_die_subnet[subnet_name].id
  route_table_id = aws_route_table.die_route_table[routetable_name].id 
}

