# Internet Gateway

vpcconfig = {
    aws_transit_gateway = [
    {
      internet_gtw_name = "internet_gateway_ejemplo"
      id                = "tgw-1234567890abcdef"
      arn               = 
      owner_id          = 
      vpc_id            = 
      tags              = "transit_gateway_caso_4"
    }
    ]  

# Nat Gateway

    aws_nat_gateway = [ 
    {
      nat_gtw_name                       = "nat_gateway_ejemplo"
      allocation_id                      = 
      connectivity_type                  = "public"
      private_ip                         = ""
      subnet_id                          = 
      secondary_allocation_ids           = [] 
      secondary_private_ip_address_count = 0
      secondary_private_ip_addresses     = []
      tags                               = "nat_gateway_caso_4"
    } 
    ]

# Customer Gateway

    aws_customer_gateway = [ 
    {
      customer_gtw_name = "customer_gateway_ejemplo"
      type              = "ipsec.1"
      bgp_asn           = 
      bgp_asn_extended  = null
      certificate_arn   = null
      device_name       = "customer-device-01"
      ip_address        = 
      tags              = "customer_gateway_caso_4"
    } 
    ]

# VPN Connection

    aws_vpn_connection = [ 
    {
      vpn_connection_name                     = "vpn_connection_ejemplo"
      customer_gateway_id                     = 
      type                                    = "ipsec.1"
      transit_gateway_id                      =
      vpn_gateway_id                          = null
      static_routes_only                      = true
      enable_acceleration                     = false
      local_ipv4_network_cidr                 = 
      local_ipv6_network_cidr                 = 
      outside_ip_address_type                 = 
      remote_ipv4_network_cidr                = 
      remote_ipv6_network_cidr                =
      transport_transit_gateway_attachment_id = 
      tunnel_inside_ip_version                = 
      tunnel1_inside_cidr                     = 
      tunnel2_inside_cidr                     = 
      tunnel1_inside_ipv6_cidr                =
      tunnel2_inside_ipv6_cidr                =
      tunnel1_preshared_key                   = 
      tunnel2_preshared_key                   = 
      tunnel1_dpd_timeout_action              = 
      tunnel2_dpd_timeout_action              = 
      tunnel1_dpd_timeout_seconds             = 
      tunnel2_dpd_timeout_seconds             = 
      tunnel1_enable_tunnel_lifecycle_control = 
      tunnel2_enable_tunnel_lifecycle_control = 
      tunnel1_ike_versions                    = 
      tunnel2_ike_versions                    = 
      tunnel1_log_options                     = 
      tunnel2_log_options                     = 
      tunnel1_phase1_dh_group_numbers         = 
      tunnel2_phase1_dh_group_numbers         = 
      tunnel1_phase1_encryption_algorithms    = 
      tunnel2_phase1_encryption_algorithms    = 
      tunnel1_phase1_integrity_algorithms     = 
      tunnel2_phase1_integrity_algorithms     = 
      tunnel1_phase1_lifetime_seconds         =
      tunnel2_phase1_lifetime_seconds         = 
      tunnel1_phase2_dh_group_numbers         = 
      tunnel2_phase2_dh_group_numbers         = 
      tunnel1_phase2_encryption_algorithms    = 
      tunnel2_phase2_encryption_algorithms    = 
      tunnel1_phase2_integrity_algorithms     = 
      tunnel2_phase2_integrity_algorithms     = 
      tunnel1_phase2_lifetime_seconds         = 
      tunnel2_phase2_lifetime_seconds         =
      tunnel1_rekey_fuzz_percentage           = 
      tunnel2_rekey_fuzz_percentage           = 
      tunnel1_rekey_margin_time_seconds       = 
      tunnel2_rekey_margin_time_seconds       = 
      tunnel1_replay_window_size              = 
      tunnel2_replay_window_size              = 
      tunnel1_startup_action                  = 
      tunnel2_startup_action                  = 
    } 
    ]

# Network firewall

    aws_networkfirewall_firewall = [ 
    {
      networkfirewall_name              = 
      delete_protection                 = 
      description                       = 
      encryption_configuration          = list(object({
        key_id =
        type =
      }))
      firewall_policy_arn               = 
      firewall_policy_change_protection = 
      name                              = 
      subnet_change_protection          = 
      subnet_mapping                    = list(object({
        ip_address_type =
        subnet_id =
      }))
      vpc_id                            = 
      tags                              = 
    }  
    ]

# Transit Gateway

    aws_transit_gateway = [ 
    {
      transit_gtw_name                   = "transit_gateway_ejemplo"
      description                        = "Simple transit gateway"
      amazon_side_asn                    = 
      auto_accept_shared_attachments     = 
      default_route_table_association    = 
      default_route_table_propagation    =
      dns_support                        = 
      security_group_referencing_support =
      multicast_support                  = 
      transit_gateway_cidr_blocks        = 
      vpn_ecmp_support                   = 
      tags                               = "transit_gateway_caso_4"
    } 
    ]

# Security Groups

    aws_security_group = [ 
    {
      description         = "simple security group"
      security_group_name = "security_group_ejemplo"

      egress = list(object({
        cidr_block       = 
        from_port        = 
        to_port          = 
        protocol         = 
        ipv6_cidr_blocks = 
      }))

      ingress = list(object({
        cidr_block       = 
        from_port        = 
        to_port          = 
        protocol         = 
        ipv6_cidr_blocks = 

      }))

      name_prefix = 
      vpc_id      = 
      tags        = 
    } 
    ]

# ACLs

    aws_network_acl = [ 
    {
      network_acl_name = "network_acl_ejemplo"
      vpc_id           = 
      subnet_ids       = 
      ingress          = 
      tags             = 

      egress = list(object({
        cidr_block       = 
        from_port        = 
        to_port          = 
        protocol         = 
        action           = 
        ipv6_cidr_blocks = 
        icmp_type        = 
        icmp_code        = 
      }))

      ingress = list(object({
        cidr_block       = 
        from_port        = 
        to_port          = 
        protocol         = 
        action           = 
        ipv6_cidr_blocks = 
        icmp_type        = 
        icmp_code        = 
      }))
    } 
    ]

}