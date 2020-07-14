variable "region" {
  default = "us-east-1"
}

variable "tenant_role_arn" {
  description = "iam role arn to assume in the tenant aws account where the vpc and tgw attachment are to be made"
}

variable "central_role_arn" {
  description = "iam role arn to assume in the central aws account where the transit gateway is and where the tgw route table will be made"
}

provider "aws" {
  alias = "tenant"
  region  = var.region
  assume_role {
    role_arn     = var.tenant_role_arn
  }
}

provider "aws" {
  alias = "central"
  region  = var.region
  assume_role {
    role_arn     = var.central_role_arn
  }
}

module "vpc-tenant" {
  source = "./modules/vpc-tenant"
   providers = {
      aws = aws.tenant
  }
  region = var.region
  environment = "test"
  map_public_ip_on_launch = "false"
  cidr_one = ""
  cidr_rest = []
  subnet_az_map = {
    "subnetOne" = {
      "cidr" = ""
      "az" = ""
      "name" = ""
    },
    subnetTwo = {
      "cidr" = ""
      "az" = ""
      "name" = ""
    }
  }
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
}

module "tgw-share" {
  source = "./modules/tgw-share"
  providers = {
    aws.central = aws.central
    aws.tenant = aws.tenant
  }
  tgw_arn = "enter arn here"
}
