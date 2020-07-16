provider "aws" {
  alias = "central"
}

provider "aws" {
  alias = "tenant"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tenant-tgw-att" {
  provider = aws.tenant
  for_each = var.subnet_vpc_map
  subnet_ids         = each.value.cidrArray
  transit_gateway_id = var.tgw_id
  vpc_id             = each.value.vpc
  dns_support = "enable"
  transit_gateway_default_route_table_association = "false"
  transit_gateway_default_route_table_propagation = "false"
}

resource "aws_ec2_transit_gateway_route_table" "tgw-rt" {
  provider = aws.central
  transit_gateway_id = var.tgw_id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-vpc-assoc" {
  provider = aws.central
  for_each = var.subnet_vpc_map
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tenant-tgw-att[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tenant-tgw-att, aws_ec2_transit_gateway_route_table.tgw-rt]
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw-rt-to-vpc" {
  for_each = var.subnet_vpc_map
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tenant-tgw-att[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tenant-tgw-att, aws_ec2_transit_gateway_route_table.tgw-rt, aws_ec2_transit_gateway_route_table_propagation.tgw-rt-to-vpc]
}
