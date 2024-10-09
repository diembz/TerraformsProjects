variable "vpcconfig" {
  description = "Configuration for the VPC module"
  type = object({
    vpc = list(object({
      region             = string
      vpc_name           = string
      availability_zones = list(string)
    }))
  })
}



