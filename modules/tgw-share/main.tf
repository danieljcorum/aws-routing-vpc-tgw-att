provider "aws" {
  alias = "central"
}


provider "aws" {
  alias = "tenant"
}

data "aws_caller_identity" "tenant" {
  provider = aws.tenant
}

resource "aws_ram_resource_share" "tgw" {
  provider = aws.central

  name = "tgw-resource-share"
  allow_external_principals = true
  tags = {
    Name = "tgw"
  }
}

resource "aws_ram_resource_association" "tgw" {
  provider = aws.central

  resource_arn       = var.tgw_arn
  resource_share_arn = aws_ram_resource_share.tgw.id
}

resource "aws_ram_principal_association" "tgw" {
  provider = aws.central

  principal          = data.aws_caller_identity.tenant.account_id
  resource_share_arn = aws_ram_resource_share.tgw.id
}

resource "aws_ram_resource_share_accepter" "receiver_accept" {
  provider = aws.tenant
  share_arn = aws_ram_principal_association.tgw.resource_share_arn
}
