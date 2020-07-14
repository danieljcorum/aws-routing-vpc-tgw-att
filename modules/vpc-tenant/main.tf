
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_one
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = "${var.environment}-VPC"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "cidr_rest" {
  count = length(var.cidr_rest)
  cidr_block = element(var.cidr_rest, count.index)
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet_az_map
  vpc_id = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.environment}-${each.value.name}-${each.value.az}"
  }
  depends_on = [aws_vpc_ipv4_cidr_block_association.cidr_rest]
}


resource "aws_route_table" "tenant-rt" {
  vpc_id = aws_vpc.vpc.id
tags = {
    Name = "${var.environment}-tenant-rt"
  }
}

resource "aws_route_table_association" "tenant-rt_ass" {
  for_each = var.subnet_az_map
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.tenant-rt.id
  depends_on = [aws_route_table.tenant-rt,aws_subnet.subnets]
}
