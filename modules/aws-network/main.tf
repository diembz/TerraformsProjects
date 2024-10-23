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

resource "aws_subnet" "mi_die_subnet" {
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

resource "aws_nat_gateway" "die_nat_gateway" {
  allocation_id                      = ""
  connectivity_type                  = ""
  private_ip                         = ""
  subnet_id                          = ""
  secondary_allocation_ids           = ""
  secondary_private_ip_address_count = ""
  secondary_private_ip_addresses     = ""
  tags = {

  }
}

resource "aws_internet_gateway" "die_internet_gateway" {
  vpc_id = ""
  tags = {

  }
}

resource "aws_customer_gateway" "die_customer_gateway" {
  type             = ""
  bgp_asn          = ""
  bgp_asn_extended = ""
  certificate_arn  = ""
  device_name      = ""
  ip_address       = ""
  tags = {

  }
}

resource "aws_ec2_transit_gateway" "die_ec2_transit_gateway" {
  description                     = ""
  amazon_side_asn                 = ""
  auto_accept_shared_attachments  = ""
  default_route_table_association = ""
  default_route_table_propagation = ""

}

resource "aws_vpn_connection" "die_vpn_connection" {
  customer_gateway_id                     = ""
  type                                    = ""
  transit_gateway_id                      = ""
  vpn_gateway_id                          = ""
  static_routes_only                      = ""
  enable_acceleration                     = ""
  local_ipv4_network_cidr                 = ""
  local_ipv6_network_cidr                 = ""
  outside_ip_address_type                 = ""
  remote_ipv4_network_cidr                = ""
  remote_ipv6_network_cidr                = ""
  transport_transit_gateway_attachment_id = ""
  tunnel_inside_ip_version                = ""
  tunnel1_inside_cidr                     = ""
  tunnel2_inside_cidr                     = ""
  tunnel1_inside_ipv6_cidr                = ""
  tunnel2_inside_ipv6_cidr                = ""
  tunnel1_preshared_key                   = ""
  tunnel2_preshared_key                   = ""
  tunnel1_dpd_timeout_action              = ""
  tunnel2_dpd_timeout_action              = ""
  tunnel1_dpd_timeout_seconds             = ""
  tunnel2_dpd_timeout_seconds             = ""
  tunnel1_enable_tunnel_lifecycle_control = ""
  tunnel2_enable_tunnel_lifecycle_control = ""
  tunnel1_ike_versions                    = ""
  tunnel2_ike_versions                    = ""
  tunnel1_log_options {

  }
  tunnel2_log_options {

  }
  tunnel1_phase1_dh_group_numbers      = []
  tunnel2_phase1_dh_group_numbers      = []
  tunnel1_phase1_encryption_algorithms = []
  tunnel2_phase1_encryption_algorithms = []
  tunnel1_phase1_integrity_algorithms  = []
  tunnel2_phase1_integrity_algorithms  = []
  tunnel1_phase1_lifetime_seconds      = ""
  tunnel2_phase1_lifetime_seconds      = ""
  tunnel1_phase2_dh_group_numbers      = []
  tunnel2_phase2_dh_group_numbers      = []
  tunnel1_phase2_encryption_algorithms = []
  tunnel2_phase2_encryption_algorithms = []
  tunnel1_phase2_integrity_algorithms  = []
  tunnel2_phase2_integrity_algorithms  = []
  tunnel1_phase2_lifetime_seconds      = ""
  tunnel2_phase2_lifetime_seconds      = ""
  tunnel1_rekey_fuzz_percentage        = ""
  tunnel2_rekey_fuzz_percentage        = ""
  tunnel1_rekey_margin_time_seconds    = ""
  tunnel2_rekey_margin_time_seconds    = ""
  tunnel1_replay_window_size           = ""
  tunnel2_replay_window_size           = ""
  tunnel1_startup_action               = ""
  tunnel2_startup_action               = ""
  tags = {

  }
}

resource "aws_security_group" "security_group_example" {
  description = ""
  egress      = ""
  ingress     = ""
  name_prefix = ""
  name        = ""
  vpc_id      = ""
  tags = {

  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = ""
  cidr_ipv4         = ""
  from_port         = ""
  ip_protocol       = ""
  to_port           = ""
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = ""
  cidr_ipv6         = ""
  from_port         = ""
  ip_protocol       = ""
  to_port           = ""
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = ""
  cidr_ipv4         = ""
  ip_protocol       = ""
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = ""
  cidr_ipv6         = ""
  ip_protocol       = ""
}
