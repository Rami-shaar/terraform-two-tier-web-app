resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "${var.region}b"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.my_igw]
}

resource "aws_route_table" "my_rt_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "assoc_pub_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.my_rt_public.id
}

resource "aws_route_table_association" "assoc_pub_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.my_rt_public.id
}

resource "aws_route_table" "my_rt_private" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_natgw.id
  }
}

resource "aws_route_table_association" "assoc_priv_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.my_rt_private.id
}

resource "aws_route_table_association" "assoc_priv_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.my_rt_private.id
}

