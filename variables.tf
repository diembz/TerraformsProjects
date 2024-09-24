variable "moduleconfig" {
  type = list(object({
    llanta = string
    puerta = number
    motor  = string
  }))
  description = "Una lista de objetos que representa varios coches"
}

# Definir otras variables para los parámetros del recurso
variable "ami" {
  type        = string
  description = "El ID de la AMI"
}

variable "instance_type" {
  type        = string
  description = "El tipo de instancia de EC2"
}

variable "nombre" {
  type        = string
  description = "El nombre de..."
}

variable "acl" {
  type        = string
  description = "El nombre de..."
}
