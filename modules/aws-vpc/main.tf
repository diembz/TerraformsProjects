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
  vpc_id            = aws_vpc.mi_die_vpc[each.value.vpc_name].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address_on_creation
  availability_zone_id                           = each.value.availability_zone_id
  customer_owned_ipv4_pool                       = each.value.customer_owned_ipv4_pool
  enable_dns64                                   = each.value.enable_dns64
  enable_lni_at_device_index                     = each.value.enable_lni_at_device_index
  enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch
  enable_resource_name_dns_a_record_on_launch    = each.value.enable_resource_name_dns_a_record_on_launch
  ipv6_cidr_block                                = each.value.ipv6_cidr_block
  ipv6_native                                    = each.value.ipv6_native
  map_customer_owned_ip_on_launch                = each.value.map_customer_owned_ip_on_launch
  map_public_ip_on_launch                        = each.value.map_public_ip_on_launch
  outpost_arn                                    = each.value.outpost_arn
  private_dns_hostname_type_on_launch            = each.value.private_dns_hostname_type_on_launch

  tags = {
    Name = each.value.subnet_name
  }
}

resource "aws_route_table" "die_route_table" { # Crear una tabla de rutas para controlar el enrutamiento del tráfico en la VPC y asignarle un nombre.
  for_each         = { for entry in var.vpcconfig.route_tables : entry.route_table_name => entry }
  vpc_id           = aws_vpc.mi_die_vpc[each.value.vpc_name].id
  propagating_vgws = each.value.propagating_vgws # Opcional: Virtual gateways para propagación

  route {
    cidr_block                 = each.value.routes.cidr_block
    ipv6_cidr_block            = each.value.routes.ipv6_cidr_block
    destination_prefix_list_id = each.value.routes.destination_prefix_list_id
    carrier_gateway_id         = each.value.routes.carrier_gateway_id
    core_network_arn           = each.value.routes.core_network_arn
    egress_only_gateway_id     = each.value.routes.egress_only_gateway_id
    gateway_id                 = each.value.routes.gateway_id
    local_gateway_id           = each.value.routes.local_gateway_id
    nat_gateway_id             = each.value.routes.nat_gateway_id
    network_interface_id       = each.value.routes.network_interface_id
    transit_gateway_id         = each.value.routes.transit_gateway_id
    vpc_endpoint_id            = each.value.routes.vpc_endpoint_id
    vpc_peering_connection_id  = each.value.routes.vpc_peering_connection_id
  }

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "mi_route_table_assoc" { # # Asocia cada subnet con la tabla de rutas para definir cómo se enruta el tráfico dentro de cada subnet.
  for_each       = { for entry in var.vpcconfig.table_association : entry.association_name => entry }
  subnet_id      = aws_subnet.mi_die_subnet[each.value.subnet_name].id
  route_table_id = aws_route_table.die_route_table[each.value.route_table_name].id
}

