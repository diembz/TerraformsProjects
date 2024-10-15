variable "moduleconfig" {
  type = object({
    instance = list(object({
      ami           = string
      instance_type = string
      tags          = list(string)
    }))
    bucket = list(object({
      name = string
      acl  = string
      tags = list(string)
    }))
  })
  description = "Un objeto que contiene la configuracion del modulo"
}

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

      # Subnet configuration
      subnets = list(object({
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


    }))
  })
}
