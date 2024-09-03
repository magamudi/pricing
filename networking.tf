

resource "aws_vpc" "pricing_demo" {
  cidr_block           = "172.16.0.0/18"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "pricing_demo" {
  vpc_id = aws_vpc.pricing_demo.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "pricing_demo" {
  vpc_id = aws_vpc.pricing_demo.id
  cidr_block = cidrsubnet(aws_vpc.pricing_demo.cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${data.aws_availability_zones.available.names[0]}_pricing_demo"
  }
}

resource "aws_route_table" "pricing_demo" {
  vpc_id = aws_vpc.pricing_demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pricing_demo.id
  }

  tags = {
    Name = "pricing_demo"
  }
}

resource "aws_route_table_association" "pricing_demo" {
  depends_on = [aws_subnet.pricing_demo]

  subnet_id      = aws_subnet.pricing_demo.id
  route_table_id = aws_route_table.pricing_demo.id
}

resource "aws_security_group" "pricing_demo" {
  name        = "pricing_demo"
  description = "pricing_demo"
  vpc_id      = aws_vpc.pricing_demo.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}