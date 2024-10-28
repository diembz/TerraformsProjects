variable "vpcconfig" {
  description = "Configuration for the VPC module"
  type = object({
    vpc = list(object({
      region                               = string
      vpc_name                             = string
      cidr_block                           = string
      ipv6_cidr_block                      = string
      ipv6_ipam_pool_id                    = string
      ipv6_netmask_length                  = string
      ipv6_cidr_block_network_border_group = string
      ipv4_ipam_pool_id                    = string
      ipv4_netmask_length                  = number
      enable_network_address_usage_metrics = bool
      enable_dns_support                   = bool
      enable_dns_hostnames                 = bool
      instance_tenancy                     = string
      assign_generated_ipv6_cidr_block     = bool
      tags                                 = map(string)
    }))
    # Subnet configuration
    subnets = list(object({
      vpc_name                                       = string
      subnet_name                                    = string
      availability_zone                              = string
      assign_ipv6_address_on_creation                = bool
      availability_zone_id                           = string
      customer_owned_ipv4_pool                       = string
      enable_dns64                                   = bool
      enable_lni_at_device_index                     = string
      enable_resource_name_dns_aaaa_record_on_launch = bool
      enable_resource_name_dns_a_record_on_launch    = bool
      ipv6_cidr_block                                = string
      ipv6_native                                    = bool
      map_customer_owned_ip_on_launch                = bool
      map_public_ip_on_launch                        = bool
      outpost_arn                                    = string
      private_dns_hostname_type_on_launch            = string
      cidr_block                                     = string
      tags                                           = map(string)
    }))

    # Route Table configuration
    route_tables = list(object({
      route_table_name = string
      propagating_vgws = list(string)
      routes = list(object({
        vpc_name                   = string
        cidr_block                 = string
        ipv6_cidr_block            = string
        destination_prefix_list_id = string
        carrier_gateway_id         = string
        core_network_arn           = string
        egress_only_gateway_id     = string
        gateway_id                 = string
        local_gateway_id           = string
        nat_gateway_id             = string
        network_interface_id       = string
        transit_gateway_id         = string
        vpc_endpoint_id            = string
        vpc_peering_connection_id  = string
      }))
    }))

    #Table Association
    table_association = list(object({
      association_name = string
      subnet_name      = string
      routetable_name  = string

    }))

    # Nat_gateway
    aws_nat_gateway = list(object({
      nat_gtw_name                       = string
      allocation_id                      = string
      connectivity_type                  = string
      private_ip                         = string
      subnet_id                          = string
      secondary_allocation_ids           = string
      secondary_private_ip_address_count = string
      secondary_private_ip_addresses     = string
      tags                               = map(string)
    }))

    # Internet_gateway
    aws_internet_gateway = list(object({
      internet_gtw_name = string
      id                = string
      arn               = string
      owner_id          = string
      vpc_id            = string
      tags              = map(string)
    }))

    # customer_gateway
    aws_customer_gateway = list(object({
      customer_gtw_name = string
      type              = string
      bgp_asn           = string
      bgp_asn_extended  = string
      certificate_arn   = string
      device_name       = string
      ip_address        = string
      tags              = map(string)
    }))

    # transit gateway
    aws_transit_gateway = list(object({
      transit_gtw_name                   = string
      description                        = string
      amazon_side_asn                    = number
      auto_accept_shared_attachments     = bool
      default_route_table_association    = bool
      default_route_table_propagation    = bool
      dns_support                        = bool
      security_group_referencing_support = bool
      multicast_support                  = bool
      transit_gateway_cidr_blocks        = string
      vpn_ecmp_support                   = bool
      tags                               = map(string)
    }))

    # Network Firewall
    aws_networkfirewall_firewall = list(object({
      networkfirewall_name              = string
      delete_protection                 = bool
      description                       = string
      encryption_configuration          = map(any)
      firewall_policy_arn               = string
      firewall_policy_change_protection = bool
      name                              = string
      subnet_change_protection          = bool
      subnet_mapping                    = map(any)
      vpc_id                            = string
      tags                              = map(any)
    }))

    # VPN connection
    aws_vpn_connection = list(object({
      vpn_connection_name                     = string
      customer_gateway_id                     = string
      type                                    = string
      transit_gateway_id                      = string
      vpn_gateway_id                          = string
      static_routes_only                      = bool
      enable_acceleration                     = bool
      local_ipv4_network_cidr                 = string
      local_ipv6_network_cidr                 = string
      outside_ip_address_type                 = string
      remote_ipv4_network_cidr                = string
      remote_ipv6_network_cidr                = string
      transport_transit_gateway_attachment_id = string
      tunnel_inside_ip_version                = string
      tunnel1_inside_cidr                     = string
      tunnel2_inside_cidr                     = string
      tunnel1_inside_ipv6_cidr                = string
      tunnel2_inside_ipv6_cidr                = string
      tunnel1_preshared_key                   = string
      tunnel2_preshared_key                   = string
      tunnel1_dpd_timeout_action              = string
      tunnel2_dpd_timeout_action              = string
      tunnel1_dpd_timeout_seconds             = number
      tunnel2_dpd_timeout_seconds             = number
      tunnel1_enable_tunnel_lifecycle_control = bool
      tunnel2_enable_tunnel_lifecycle_control = bool
      tunnel1_ike_versions                    = list(string)
      tunnel2_ike_versions                    = list(string)
      log_enabled_1                           = bool
      log_group_arn_1                         = string
      log_output_format_1                     = string
      log_enabled_2                           = bool
      log_group_arn_2                         = string
      log_output_format_2                     = string
      tunnel2_log_options                     = map(any)
      tunnel1_phase1_dh_group_numbers         = list(number)
      tunnel2_phase1_dh_group_numbers         = list(number)
      tunnel1_phase1_encryption_algorithms    = list(string)
      tunnel2_phase1_encryption_algorithms    = list(string)
      tunnel1_phase1_integrity_algorithms     = list(string)
      tunnel2_phase1_integrity_algorithms     = list(string)
      tunnel1_phase1_lifetime_seconds         = number
      tunnel2_phase1_lifetime_seconds         = number
      tunnel1_phase2_dh_group_numbers         = list(number)
      tunnel2_phase2_dh_group_numbers         = list(number)
      tunnel1_phase2_encryption_algorithms    = list(string)
      tunnel2_phase2_encryption_algorithms    = list(string)
      tunnel1_phase2_integrity_algorithms     = list(string)
      tunnel2_phase2_integrity_algorithms     = list(string)
      tunnel1_phase2_lifetime_seconds         = number
      tunnel2_phase2_lifetime_seconds         = number
      tunnel1_rekey_fuzz_percentage           = number
      tunnel2_rekey_fuzz_percentage           = number
      tunnel1_rekey_margin_time_seconds       = number
      tunnel2_rekey_margin_time_seconds       = number
      tunnel1_replay_window_size              = number
      tunnel2_replay_window_size              = number
      tunnel1_startup_action                  = string
      tunnel2_startup_action                  = string
    }))

    # Security Group
    aws_security_group = list(object({
      description         = string
      name_prefix         = string
      security_group_name = string
      egress              = map(any)
      ingress             = map(any)
      vpc_id              = string
      tags                = map(string)
    }))

    # ACL
    aws_network_acl = list(object({
      network_acl_name = string
      vpc_id           = string
      subnet_ids       = string
      ingress          = string
      tags             = map(string)
      egress           = map(any)
      ingress          = map(any)
    }))

  })
}








