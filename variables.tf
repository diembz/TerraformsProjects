variable "moduleconfig" {
  type = object({
    instance = list(object({
      ami = string
      instance_type = string
      tags = list(string)
    }))
    bucket = list(object({
      name = string
      acl = string
      tags = list(strigs)
    }))
  })
  description = "Un objeto que contiene la configuracion del modulo"
}

