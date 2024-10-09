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
      region             = string
      vpc_name           = string
      availability_zones = list(string)
    }))
  })
}
