resource "aws_instance" "mi_instancia" {
  for_each = { for idx, instance in var.moduleconfig.instance : idx => instance }

  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    for tag in each.value.tags : tag => tag
  }
}

resource "aws_s3_bucket" "mi_bucket" {
  for_each = { for idx, bucket in var.moduleconfig.bucket : idx => bucket }

  bucket = each.value.name
  acl    = each.value.acl

  tags = {
    for tag in each.value.tags : tag => tag
  }
}
