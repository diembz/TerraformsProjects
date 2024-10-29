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

# SUBNET
resource "aws_subnet" "mi_die_subnet" {
  for_each                                       = { for entry in var.vpcconfig.subnets : entry.subnet_name => entry }
  vpc_id                                         = aws_vpc.mi_die_vpc[each.value.vpc_name].id
  cidr_block                                     = each.value.cidr_block
  availability_zone                              = each.value.availability_zone
  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address_on_creation
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
  tags                                           = each.value.tags
}

# ROUTE TABLE
resource "aws_route_table" "die_route_table" { # Crear una tabla de rutas para controlar el enrutamiento del tráfico en la VPC y asignarle un nombre.
  for_each         = { for entry in var.vpcconfig.route_tables : entry.route_table_name => entry }
  vpc_id           = aws_vpc.mi_die_vpc[each.value.vpc_name].id
  propagating_vgws = each.value.propagating_vgws # Opcional: Virtual gateways para propagación

  route {
    cidr_block                 = each.value.routes[0].cidr_block
    ipv6_cidr_block            = each.value.routes[0].ipv6_cidr_block
    destination_prefix_list_id = each.value.routes[0].destination_prefix_list_id
    carrier_gateway_id         = each.value.routes[0].carrier_gateway_id
    core_network_arn           = each.value.routes[0].core_network_arn
    egress_only_gateway_id     = each.value.routes[0].egress_only_gateway_id
    gateway_id                 = each.value.routes[0].gateway_id
    local_gateway_id           = each.value.routes[0].local_gateway_id
    nat_gateway_id             = each.value.routes[0].nat_gateway_id
    network_interface_id       = each.value.routes[0].network_interface_id
    transit_gateway_id         = each.value.routes[0].transit_gateway_id
    vpc_endpoint_id            = each.value.routes[0].vpc_endpoint_id
    vpc_peering_connection_id  = each.value.routes[0].vpc_peering_connection_id
  }

  tags = each.value.tags
}

# ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "mi_route_table_assoc" { # # Asocia cada subnet con la tabla de rutas para definir cómo se enruta el tráfico dentro de cada subnet.
  for_each       = { for entry in var.vpcconfig.table_association : entry.association_name => entry }
  subnet_id      = aws_subnet.mi_die_subnet[each.value.subnet_name].id
  route_table_id = aws_route_table.die_route_table[each.value.route_table_name].id
}

# NAT GATEWAY
resource "aws_nat_gateway" "die_nat_gateway" {
  for_each                           = { for entry in var.vpcconfig.aws_nat_gateway : entry.nat_gtw_name => entry }
  allocation_id                      = each.value.allocation_id
  connectivity_type                  = each.value.connectivity_type
  private_ip                         = each.value.private_ip
  subnet_id                          = each.value.subnet_id
  secondary_allocation_ids           = each.value.secondary_allocation_ids
  secondary_private_ip_address_count = each.value.secondary_private_ip_address_count
  secondary_private_ip_addresses     = each.value.secondary_private_ip_addresses
  tags                               = each.value.tags
}

# Internet Gateway
resource "aws_internet_gateway" "die_internet_gateway" {
  for_each = { for entry in var.vpcconfig.aws_internet_gateway : entry.internet_gtw_name => entry }
  vpc_id   = aws_vpc.mi_die_vpc[each.value.vpc_name].id #INVESTIGAR
  tags     = each.value.tags
}

# Customer Gateway
resource "aws_customer_gateway" "die_customer_gateway" {
  for_each         = { for entry in var.vpcconfig.aws_customer_gateway : entry.customer_gtw_name => entry }
  type             = each.value.type
  bgp_asn          = each.value.bgp_asn
  bgp_asn_extended = each.value.bgp_asn_extended
  certificate_arn  = each.value.certificate_arn
  device_name      = each.value.device_name
  ip_address       = each.value.ip_address
  tags             = each.value.tags
}

# transit gateway
resource "aws_ec2_transit_gateway" "die_ec2_transit_gateway" {
  for_each                           = { for entry in var.vpcconfig.aws_transit_gateway : entry.transit_gtw_name => entry }
  description                        = each.value.description
  amazon_side_asn                    = each.value.amazon_side_asn
  auto_accept_shared_attachments     = each.value.auto_accept_shared_attachments
  default_route_table_association    = each.value.default_route_table_association
  default_route_table_propagation    = each.value.default_route_table_propagation
  dns_support                        = each.value.dns_support
  security_group_referencing_support = each.value.security_group_referencing_support
  multicast_support                  = each.value.multicast_support
  transit_gateway_cidr_blocks        = each.value.transit_gateway_cidr_blocks
  vpn_ecmp_support                   = each.value.vpn_ecmp_support
  tags                               = each.value.tags
}

# Network Firewall
resource "aws_networkfirewall_firewall" "die_networkfirewall_firewall" {
  for_each          = { for entry in var.vpcconfig.aws_networkfirewall_firewall : entry.networkfirewall_name => entry }
  delete_protection = each.value.delete_protection
  description       = each.value.description
  encryption_configuration {
    type   = each.value.encryption_configuration[0].type
    key_id = each.value.encryption_configuration[0].key_id
  }
  firewall_policy_arn               = each.value.firewall_policy_arn
  firewall_policy_change_protection = each.value.firewall_policy_change_protection
  name                              = each.value.name
  subnet_change_protection          = each.value.subnet_change_protection
  subnet_mapping {
    subnet_id       = each.value.subnet_mapping[0].subnet_id
    ip_address_type = each.value.subnet_mapping[0].ip_address_type
  }
  vpc_id = each.value.vpc_id
  tags   = each.value.tags
}

# VPN CONNECTION
resource "aws_vpn_connection" "die_vpn_connection" {
  for_each                                = { for entry in var.vpcconfig.aws_vpn_connection : entry.vpn_connection_name => entry }
  customer_gateway_id                     = each.value.customer_gateway_id
  type                                    = each.value.type
  transit_gateway_id                      = each.value.transit_gateway_id
  vpn_gateway_id                          = each.value.vpn_gateway_id
  static_routes_only                      = each.value.static_routes_only
  enable_acceleration                     = each.value.enable_acceleration
  local_ipv4_network_cidr                 = each.value.local_ipv4_network_cidr
  local_ipv6_network_cidr                 = each.value.local_ipv6_network_cidr
  outside_ip_address_type                 = each.value.outside_ip_address_type
  remote_ipv4_network_cidr                = each.value.remote_ipv4_network_cidr
  remote_ipv6_network_cidr                = each.value.remote_ipv6_network_cidr
  transport_transit_gateway_attachment_id = each.value.transport_transit_gateway_attachment_id
  tunnel_inside_ip_version                = each.value.tunnel_inside_ip_version
  tunnel1_inside_cidr                     = each.value.tunnel1_inside_cidr
  tunnel2_inside_cidr                     = each.value.tunnel2_inside_cidr
  tunnel1_inside_ipv6_cidr                = each.value.tunnel1_inside_ipv6_cidr
  tunnel2_inside_ipv6_cidr                = each.value.tunnel2_inside_ipv6_cidr
  tunnel1_preshared_key                   = each.value.tunnel1_preshared_key
  tunnel2_preshared_key                   = each.value.tunnel1_preshared_key
  tunnel1_dpd_timeout_action              = each.value.tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_action              = each.value.tunnel2_dpd_timeout_action
  tunnel1_dpd_timeout_seconds             = each.value.tunnel1_dpd_timeout_seconds
  tunnel2_dpd_timeout_seconds             = each.value.tunnel2_dpd_timeout_seconds
  tunnel1_enable_tunnel_lifecycle_control = each.value.tunnel1_enable_tunnel_lifecycle_control
  tunnel2_enable_tunnel_lifecycle_control = each.value.tunnel2_enable_tunnel_lifecycle_control
  tunnel1_ike_versions                    = each.value.tunnel1_ike_versions
  tunnel2_ike_versions                    = each.value.tunnel2_ike_versions
  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = each.value.log_enabled_1
      log_group_arn     = each.value.log_group_arn_1
      log_output_format = each.value.log_output_format_1
    }
  }
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = each.value.log_enabled_2
      log_group_arn     = each.value.log_group_arn_2
      log_output_format = each.value.log_output_format_2
    }
  }
  tunnel1_phase1_dh_group_numbers      = each.value.tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = each.value.tunnel2_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = each.value.tunnel1_phase1_encryption_algorithms
  tunnel2_phase1_encryption_algorithms = each.value.tunnel2_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = each.value.tunnel1_phase1_integrity_algorithms
  tunnel2_phase1_integrity_algorithms  = each.value.tunnel2_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = each.value.tunnel1_phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds      = each.value.tunnel2_phase1_lifetime_seconds
  tunnel1_phase2_dh_group_numbers      = each.value.tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = each.value.tunnel2_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = each.value.tunnel1_phase2_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = each.value.tunnel2_phase1_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = each.value.tunnel1_phase2_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = each.value.tunnel2_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = each.value.tunnel1_phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds      = each.value.tunnel2_phase2_lifetime_seconds
  tunnel1_rekey_fuzz_percentage        = each.value.tunnel1_rekey_fuzz_percentage
  tunnel2_rekey_fuzz_percentage        = each.value.tunnel2_rekey_fuzz_percentage
  tunnel1_rekey_margin_time_seconds    = each.value.tunnel1_rekey_margin_time_seconds
  tunnel2_rekey_margin_time_seconds    = each.value.tunnel2_rekey_margin_time_seconds
  tunnel1_replay_window_size           = each.value.tunnel1_replay_window_size
  tunnel2_replay_window_size           = each.value.tunnel2_replay_window_size
  tunnel1_startup_action               = each.value.tunnel1_startup_action
  tunnel2_startup_action               = each.value.tunnel2_startup_action
  tags                                 = each.value.tags
}

# Security Group
resource "aws_security_group" "security_group_example" {
  for_each    = { for entry in var.vpcconfig.aws_security_group : entry.security_group_name => entry }
  description = each.value.description
  egress {
    cidr_blocks      = each.value.egress[0].cidr_blocks
    from_port        = each.value.egress[0].from_port
    to_port          = each.value.egress[0].to_port
    protocol         = each.value.egress[0].protocol
    ipv6_cidr_blocks = each.value.egress[0].ipv6_cidr_blocks
    description      = each.value.egress[0].description
    prefix_list_ids  = each.value.egress[0].prefix_list_ids
    security_groups  = each.value.egress[0].security_groups
    self             = each.value.egress[0].self
  }
  ingress {
    cidr_blocks      = each.value.ingress[0].cidr_blocks
    from_port        = each.value.ingress[0].from_port
    to_port          = each.value.ingress[0].to_port
    protocol         = each.value.ingress[0].protocol
    ipv6_cidr_blocks = each.value.ingress[0].ipv6_cidr_blocks
    description      = each.value.ingress[0].description
    prefix_list_ids  = each.value.ingress[0].prefix_list_ids
    security_groups  = each.value.ingress[0].security_groups
    self             = each.value.ingress[0].self
  }
  name_prefix            = each.value.name_prefix
  revoke_rules_on_delete = each.value.revoke_rules_on_delete
  vpc_id                 = each.value.vpc_id
  tags                   = each.value.tags
}

# ACL

resource "aws_network_acl" "die_network_acl" {
  for_each   = { for entry in var.vpcconfig.aws_network_acl : entry.network_acl_name => entry }
  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.subnet_ids
  ingress {
    cidr_block = each.value.ingress[0].cidr_block
    from_port  = each.value.ingress[0].from_port
    to_port    = each.value.ingress[0].to_port
    protocol   = each.value.ingress[0].protocol
    action     = each.value.ingress[0].action
    icmp_type  = each.value.ingress[0].icmp_type
    icmp_code  = each.value.ingress[0].icmp_code
    rule_no    = each.value.ingress[0].rule_no
  }
  egress {
    cidr_block = each.value.egress[0].cidr_block
    from_port  = each.value.egress[0].from_port
    to_port    = each.value.egress[0].to_port
    protocol   = each.value.egress[0].protocol
    action     = each.value.egress[0].action
    icmp_type  = each.value.egress[0].icmp_type
    icmp_code  = each.value.egress[0].icmp_code
    rule_no    = each.value.egress[0].rule_no
  }
  tags = each.value.tags
}
