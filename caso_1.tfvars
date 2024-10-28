vpcconfig = {
  vpc = [
    # VPC 1: 3 SubNets en diferentes AZs
    {
      region                               = "us-west-1"
      vpc_name                             = "vpc-1"
      cidr_block                           = "10.0.0.0/16"
      ipv6_cidr_block                      = null
      ipv6_ipam_pool_id                    = null
      ipv6_netmask_length                  = null
      ipv6_cidr_block_network_border_group = null
      ipv4_ipam_pool_id                    = null
      ipv4_netmask_length                  = 28
      enable_network_address_usage_metrics = true
      enable_dns_support                   = true
      enable_dns_hostnames                 = true
      instance_tenancy                     = "default"
      assign_generated_ipv6_cidr_block     = false
      tags = {
        Name = "vpc-1"
      }
    },
  ]

  # Subnet configuration
  subnets = [
    {
      subnet_name                                    = "subnet 1"
      vpc_name                                       = "vpc-1"
      availability_zone                              = "us-west-1a"
      assign_ipv6_address_on_creation                = false
      availability_zone_id                           = null
      customer_owned_ipv4_pool                       = null
      enable_dns64                                   = false
      enable_lni_at_device_index                     = null
      enable_resource_name_dns_aaaa_record_on_launch = false
      enable_resource_name_dns_a_record_on_launch    = false
      ipv6_cidr_block                                = null
      ipv6_native                                    = false
      map_customer_owned_ip_on_launch                = false
      map_public_ip_on_launch                        = false
      outpost_arn                                    = null
      private_dns_hostname_type_on_launch            = null
      cidr_block                                     = "10.0.1.0/24"
      tags = {
        Name = "Subnet-1"
      }
    },
    {
      subnet_name                                    = "subnet 2"
      vpc_name                                       = "vpc-1"
      availability_zone                              = "us-west-1b"
      assign_ipv6_address_on_creation                = false
      availability_zone_id                           = null
      customer_owned_ipv4_pool                       = null
      enable_dns64                                   = false
      enable_lni_at_device_index                     = null
      enable_resource_name_dns_aaaa_record_on_launch = false
      enable_resource_name_dns_a_record_on_launch    = false
      ipv6_cidr_block                                = null
      ipv6_native                                    = false
      map_customer_owned_ip_on_launch                = false
      map_public_ip_on_launch                        = false
      outpost_arn                                    = null
      private_dns_hostname_type_on_launch            = null
      cidr_block                                     = "10.0.2.0/24"
      tags = {
        Name = "Subnet-2"
      }
    },
    {
      subnet_name                                    = "subnet 3"
      vpc_name                                       = "vpc-1"
      availability_zone                              = "us-west-1c"
      assign_ipv6_address_on_creation                = false
      availability_zone_id                           = null
      customer_owned_ipv4_pool                       = null
      enable_dns64                                   = false
      enable_lni_at_device_index                     = null
      enable_resource_name_dns_aaaa_record_on_launch = false
      enable_resource_name_dns_a_record_on_launch    = false
      ipv6_cidr_block                                = null
      ipv6_native                                    = false
      map_customer_owned_ip_on_launch                = false
      map_public_ip_on_launch                        = false
      outpost_arn                                    = null
      private_dns_hostname_type_on_launch            = null
      cidr_block                                     = "10.0.3.0/24"
      tags = {
        Name = "Subnet-3"
      }
    }

  ]

  # Route Table configuration
  route_tables = [
    {
      propagating_vgws = []
      route_table_name = "route_table_1"
      routes = [
        {
          vpc_name                   = "vpc-1"
          cidr_block                 = "10.0.0.0/16"
          ipv6_cidr_block            = null
          destination_prefix_list_id = null
          carrier_gateway_id         = null
          core_network_arn           = null
          egress_only_gateway_id     = null
          gateway_id                 = "igw-123456"
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

  #Table Association
  table_association = [
    {
      association_name = "ass-1"
      subnet_name      = "subnet 1"
      routetable_name  = "route_table_1"
    },
    {
      association_name = "ass-2"
      subnet_name      = "subnet 2"
      routetable_name  = "route_table_1"
    },
    {
      association_name = "ass-3"
      subnet_name      = "subnet 3"
      routetable_name  = "route_table_1"
    }
  ]
}