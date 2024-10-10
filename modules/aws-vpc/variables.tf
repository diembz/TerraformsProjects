variable "vpcconfig" {
  description = "Configuration for the VPC module"
  type = object({
    vpc = list(object({
      region             = string
      vpc_name           = string
      cidr_block = string
      ipv6_cidr_block = string
      ipv6_ipam_pool_id = string
      ipv6_netmask_length = string
      ipv6_cidr_block_network_border_group = string
      ipv4_ipam_pool_id   = string
      ipv4_netmask_length = number

      enable_network_address_usage_metrics = bool
      enable_dns_support   = bool
      enable_dns_hostnames = bool
      instance_tenancy     = string

      assign_generated_ipv6_cidr_block = bool

      tags = map(string)
    }))
  })
}



