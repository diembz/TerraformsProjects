provider "aws" {                       # Configuración del proveedor AWS.
  region = var.vpcconfig.vpc[0].region # La región se obtiene de la primera configuración en la lista vpcconfig.vpc
}

data "aws_region" "current" {} # Data source que obtiene la información de la región actual en AWS

resource "aws_vpc_ipam" "test" { # Crear un VPC IPAM para gestionar direcciones IP en la región especificada.
  operating_regions {            # Esto ayuda a automatizar la asignación de IPs y evita conflictos.
    region_name = var.vpcconfig.vpc[0].region
  }
}

resource "aws_vpc_ipam_pool" "test" { # Crear un pool de direcciones IP en el IPAM.
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.test.private_default_scope_id
  locale         = var.vpcconfig.vpc[0].region
}

resource "aws_vpc_ipam_pool_cidr" "test" { # Asignar un rango CIDR al pool de IPs del IPAM.
  ipam_pool_id = aws_vpc_ipam_pool.test.id
  cidr         = "172.20.0.0/16"
}

resource "aws_vpc" "mi_die_vpc" { # Crear una VPC y asignar direcciones IP desde el pool del IPAM.
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.test.id
  ipv4_netmask_length = 28

  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = var.vpcconfig.vpc[0].vpc_name
  }

  depends_on = [
    aws_vpc_ipam_pool_cidr.test
  ]
}

resource "aws_subnet" "mi_die_subnet" { # Crear múltiples subnets, una por cada Availability Zone, asignándoles bloques CIDR desde el IPAM y etiquetándolas.
  count             = length(var.vpcconfig.vpc[0].availability_zones)
  vpc_id            = aws_vpc.mi_die_vpc.id
  cidr_block        = cidrsubnet(aws_vpc_ipam_pool_cidr.test.cidr, 8, count.index)
  availability_zone = var.vpcconfig.vpc[0].availability_zones[count.index]

  tags = {
    Name = format("Subnet-%s", count.index)
  }
}

resource "aws_route_table" "die_route_table" { # Crear una tabla de rutas para controlar el enrutamiento del tráfico en la VPC y asignarle un nombre.
  vpc_id = aws_vpc.mi_die_vpc.id

  tags = {
    Name = "RouteTable"
  }
}

resource "aws_route_table_association" "mi_route_table_assoc" { # # Asocia cada subnet con la tabla de rutas para definir cómo se enruta el tráfico dentro de cada subnet.
  count          = length(aws_subnet.mi_die_subnet)
  subnet_id      = aws_subnet.mi_die_subnet[count.index].id
  route_table_id = aws_route_table.die_route_table.id
}

