vpcconfig = {
  # VPC
  vpc = [
    {
      region                               = "us-west-1"
      vpc_name                             = "mi-vpc-ejemplo"
      cidr_block                           = "10.0.0.0/16"
      ipv6_cidr_block                      = null
      ipv6_ipam_pool_id                    = null
      ipv6_netmask_length                  = null
      ipv6_cidr_block_network_border_group = null
      ipv4_ipam_pool_id                    = null
      ipv4_netmask_length                  = null
      enable_network_address_usage_metrics = true
      enable_dns_support                   = true
      enable_dns_hostnames                 = true
      instance_tenancy                     = "default"
      assign_generated_ipv6_cidr_block     = false
      tags                                 = { "Name" = "mi-vpc-ejemplo", "Environment" = "development" }
    }
  ]


  # Table association
  table_association = [
    {
      association_name = "public-association"
      subnet_name      = "subnet-publica"
      route_table_name  = "public-route-table"
    }
  ]


  # Subnets
  subnets = [
    {
      vpc_name                                       = "mi-vpc-ejemplo"
      subnet_name                                    = "subnet-publica"
      availability_zone                              = "us-east-1a"
      assign_ipv6_address_on_creation                = false
      customer_owned_ipv4_pool                       = ""
      enable_dns64                                   = false
      enable_lni_at_device_index                     = null
      enable_resource_name_dns_aaaa_record_on_launch = false
      enable_resource_name_dns_a_record_on_launch    = true
      ipv6_cidr_block                                = null
      ipv6_native                                    = false
      map_customer_owned_ip_on_launch                = false
      map_public_ip_on_launch                        = true
      outpost_arn                                    = ""
      private_dns_hostname_type_on_launch            = "ip-name"
      cidr_block                                     = "10.0.1.0/24"
      tags                                           = { "Name" = "subnet-publica", "Environment" = "development" }
    },
    {
      vpc_name                                       = "mi-vpc-ejemplo"
      subnet_name                                    = "subnet-privada"
      availability_zone                              = "us-east-1b"
      assign_ipv6_address_on_creation                = false
      availability_zone_id                           = "use1-az2"
      customer_owned_ipv4_pool                       = ""
      enable_dns64                                   = false
      enable_lni_at_device_index                     = null
      enable_resource_name_dns_aaaa_record_on_launch = false
      enable_resource_name_dns_a_record_on_launch    = false
      ipv6_cidr_block                                = null
      ipv6_native                                    = false
      map_customer_owned_ip_on_launch                = false
      map_public_ip_on_launch                        = false
      outpost_arn                                    = ""
      private_dns_hostname_type_on_launch            = "resource-name"
      cidr_block                                     = "10.0.2.0/24"
      tags                                           = { "Name" = "subnet-privada", "Environment" = "development" }
    }
  ]


  # Route tables
  route_tables = [
    {
      route_table_name = "public-route-table"
      propagating_vgws = []
      vpc_name                   = "mi-vpc-ejemplo"
      tags = {
        "tag_1" = "ejemplo1"
        "tag_2" = "ejemplo2"
      }
      routes = [
        {
          cidr_block                 = "0.0.0.0/0"
          ipv6_cidr_block            = "::/0"
          destination_prefix_list_id = null
          carrier_gateway_id         = null
          core_network_arn           = null
          egress_only_gateway_id     = null
          gateway_id                 = "igw-0a1b2c3d4e5f67890"
          local_gateway_id           = null
          nat_gateway_id             = null
          network_interface_id       = null
          transit_gateway_id         = null
          vpc_endpoint_id            = null
          vpc_peering_connection_id  = null
        }
      ]
    }
  ]


  # Nat Gateway

  aws_nat_gateway = [
    {
      nat_gtw_name                       = "nat_gateway_ejemplo"
      allocation_id                      = "eipalloc-0a1b2c3d4e5f67890"
      connectivity_type                  = "public"
      private_ip                         = null
      subnet_id                          = "subnet-0a1b2c3d4e5f67890"
      secondary_allocation_ids           = []
      secondary_private_ip_address_count = null
      secondary_private_ip_addresses     = []
      tags = {
        "Name"        = "nat_gateway_ejemplo"
        "Environment" = "development"
      }
    }
  ]


  # Internet_gateway
  aws_internet_gateway = [
    {
      internet_gtw_name = "internet_gateway_ejemplo"
      vpc_name            = "mi-vpc-ejemplo"
      tags              = { "Name" = "internet_gateway_ejemplo", "Environment" = "development" }
    }
  ]

  # Customer Gateway

  aws_customer_gateway = [
    {
      customer_gtw_name = "customer_gateway_ejemplo"
      type              = "ipsec.1"
      bgp_asn           = 65000
      bgp_asn_extended  = null
      certificate_arn   = null
      device_name       = "customer-device-01"
      ip_address        = "203.0.113.25"
      tags = {
        "Name"        = "customer_gateway_ejemplo"
        "Environment" = "development"
      }
    }
  ]


  # VPN Connection

  aws_vpn_connection = [
    {
      vpn_connection_name                     = "vpn_connection_ejemplo"
      customer_gateway_id                     = "cgw-0a1b2c3d4e5f67890"
      type                                    = "ipsec.1"
      transit_gateway_id                      = "tgw-1234567890abcdef"
      vpn_gateway_id                          = null
      static_routes_only                      = true
      enable_acceleration                     = false
      local_ipv4_network_cidr                 = "10.0.0.0/16"
      local_ipv6_network_cidr                 = null
      outside_ip_address_type                 = "PublicIpv4"
      remote_ipv4_network_cidr                = "192.168.1.0/24"
      remote_ipv6_network_cidr                = null
      transport_transit_gateway_attachment_id = "tgw-attach-0a1b2c3d4e5f67890"
      tunnel_inside_ip_version                = "ipv4"
      tunnel1_inside_cidr                     = "169.254.6.0/30"
      tunnel2_inside_cidr                     = "169.254.6.0/30"
      tunnel1_inside_ipv6_cidr                = null # Nuevo campo
      tunnel2_inside_ipv6_cidr                = null # Nuevo campo
      tunnel1_preshared_key                   = "examplekey1"
      tunnel2_preshared_key                   = "examplekey2"
      tunnel1_dpd_timeout_action              = "restart"
      tunnel2_dpd_timeout_action              = "restart"
      tunnel1_dpd_timeout_seconds             = 30
      tunnel2_dpd_timeout_seconds             = 30
      tunnel1_enable_tunnel_lifecycle_control = true
      tunnel2_enable_tunnel_lifecycle_control = true
      tunnel1_ike_versions                    = ["ikev2"]
      tunnel2_ike_versions                    = ["ikev2"]
      log_enabled_1                           = true
      log_group_arn_1                         = "arn:aws:logs:us-east-1:123456789012:log-group:log-group-1"
      log_output_format_1                     = "json"
      log_enabled_2                           = false
      log_group_arn_2                         = "arn:aws:logs:us-east-1:123456789012:log-group:log-group-2"
      log_output_format_2                     = "text"
      tunnel1_phase1_dh_group_numbers         = [14]
      tunnel2_phase1_dh_group_numbers         = [14]
      tunnel1_phase1_encryption_algorithms    = ["AES128"]
      tunnel2_phase1_encryption_algorithms    = ["AES128"]
      tunnel1_phase1_integrity_algorithms     = ["SHA1"]
      tunnel2_phase1_integrity_algorithms     = ["SHA2-256"]
      tunnel1_phase1_lifetime_seconds         = 28800
      tunnel2_phase1_lifetime_seconds         = 28800
      tunnel1_phase2_dh_group_numbers         = [14]
      tunnel2_phase2_dh_group_numbers         = [14]
      tunnel1_phase2_encryption_algorithms    = ["AES128"]
      tunnel2_phase2_encryption_algorithms    = ["AES128"]
      tunnel1_phase2_integrity_algorithms     = ["SHA2-256"]
      tunnel2_phase2_integrity_algorithms     = ["SHA2-256"]
      tunnel1_phase2_lifetime_seconds         = 3600
      tunnel2_phase2_lifetime_seconds         = 3600
      tunnel1_rekey_fuzz_percentage           = 100
      tunnel2_rekey_fuzz_percentage           = 100
      tunnel1_rekey_margin_time_seconds       = 540
      tunnel2_rekey_margin_time_seconds       = 540
      tunnel1_replay_window_size              = 1024
      tunnel2_replay_window_size              = 1024
      tunnel1_startup_action                  = "start"
      tunnel2_startup_action                  = "start"
      tags = {
        "tag_1" = "EjemploTag1"
        "tag_2" = "EjemploTag2"
      }
    }
  ]


  # Network firewall

  aws_networkfirewall_firewall = [
    {
      networkfirewall_name = "network_firewall_ejemplo"
      delete_protection    = false
      description          = "Network firewall example"
      encryption_configuration = [
        {
          key_id = "alias/aws/firewall"
          type   = "CUSTOMER_KMS"
        }
      ]
      firewall_policy_arn               = "arn:aws:network-firewall:us-east-1:123456789012:firewall-policy/firewall-policy-ejemplo"
      firewall_policy_change_protection = false
      name                              = "firewall-example"
      subnet_change_protection          = false

      # Aseguramos que el `subnet_mapping` sea un map.
      subnet_mapping = [
        {
          subnet_id       = "subnet-0a1b2c3d4e5f67890"
          ip_address_type = "IPV4"
        }
      ]


      vpc_id = "vpc-0a1b2c3d4e5f67890"
      tags = {
        "Name"        = "network_firewall_ejemplo"
        "Environment" = "development"
      }
    }
  ]

  # Transit Gateway

  aws_transit_gateway = [
    {
      transit_gtw_name                   = "transit_gateway_ejemplo"
      description                        = "Simple transit gateway"
      amazon_side_asn                    = 64512
      auto_accept_shared_attachments     = "enable"
      default_route_table_association    = "enable"
      default_route_table_propagation    = "enable"
      dns_support                        = "enable"
      security_group_referencing_support = "disable"
      multicast_support                  = "disable"
      transit_gateway_cidr_blocks        = ["10.0.0.0/24"]
      vpn_ecmp_support                   = "disable"
      tags = {
        "Name"        = "transit_gateway_ejemplo",
        "Environment" = "development"
      }
    }
  ]


  # Security Groups

  aws_security_group = [
    {
      description            = "simple security group"
      security_group_name    = "security_group_example"
      revoke_rules_on_delete = false
      egress = [{
        cidr_blocks      = ["0.0.0.0/0"]
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        description      = "Permitir trafico HTTP saliente"
        prefix_list_ids  = ["pl-12345678"]
        security_groups  = ["sg-0a1b2c3d4e5f67890"]
        self             = false
        ipv6_cidr_blocks = ["::/0"]
        action           = "allow"
      }]
      ingress = [{
        cidr_blocks      = ["0.0.0.0/0"]
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        description      = "Permitir acceso SSH"
        prefix_list_ids  = []
        security_groups  = ["sg-0a1b2c3d4e5f67890"]
        self             = false
        ipv6_cidr_blocks = ["::/0"]
        action           = "allow"
      }]
      name_prefix = "ejemplo-"
      vpc_id      = "vpc-0a1b2c3d4e5f67890"
      tags = {
        "Name"        = "security_group_ejemplo",
        "Environment" = "development"
      }
    }
  ]


  # ACLs

  aws_network_acl = [
    {
      network_acl_name = "network_acl_ejemplo"
      vpc_id           = "vpc-0a1b2c3d4e5f67890"
      subnet_ids       = ["subnet-0a1b2c3d4e5f67890"]
      egress = [
        {
          cidr_block       = "0.0.0.0/0"
          from_port        = 0
          to_port          = 0
          protocol         = "-1"
          action           = "allow"
          ipv6_cidr_blocks = ["::/0"]
          icmp_type        = 0
          icmp_code        = 0
          rule_no          = 100
        }
      ]
      ingress = [
        {
          cidr_block       = "0.0.0.0/0"
          from_port        = 80
          to_port          = 80
          protocol         = "tcp"
          action           = "allow"
          ipv6_cidr_blocks = []
          icmp_type        = 0
          icmp_code        = 0
          rule_no = 100
        }
      ]
      tags = {
        "Name"        = "network_acl_ejemplo"
        "Environment" = "development"
      }
    }
  ]

}
