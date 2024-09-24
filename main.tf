resource "aws_instance" "mi_instancia" {
  for_each      = { for idx, coche in var.lista_de_objetos : idx => coche }
  ami           = var.ami
  instance_type = each.value.motor  # Usamos el valor del atributo 'motor'

  tags = {
    "Nombre" = "Servidor de Prueba"
    "Llanta" = each.value.llanta  # Usamos el valor del atributo 'llanta'
  }
}

resource "aws_s3_bucket" "mi_bucket" {
  for_each = { for idx, coche in var.lista_de_objetos : idx => coche }
  bucket   = "mi-bucket-${each.key}"  # Usamos la clave 'each.key' para hacer el nombre único
  acl      = "private"

  tags = {
    "Llanta" = each.value.llanta  # Usamos el valor del atributo 'llanta'
  }
}
