resource "aws_instance" "mi_instancia" {
  for_each      = { for idx, coche in var.lista_de_objetos : idx => coche }
  ami           = var.ami
  instance_type = each.value.motor  # Usamos el valor del atributo 'motor'

  tags = {
    "Nombre" = "Servidor de Prueba"
    "Llanta" = each.value.llanta  # Usamos el valor del atributo 'llanta'
  }
}
