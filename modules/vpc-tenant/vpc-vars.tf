variable "region" {
  default = "us-gov-west-1"
}
variable "environment" {
  description = "prod, dev, stage, etc"
  default = "prod"
}
variable "map_public_ip_on_launch" {
  description = "true/false"
  default = "false"
}

variable "cidr_one" {
  description = "cidr block for vpc"
  default = ""
}

variable "cidr_rest" {
  description = "rest of the cidrs for other vpcs"
}

variable "subnet_az_map" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
}

variable "instance_tenancy" {
  description = "default or dedicated instances"
  default = "default"
}

variable "enable_dns_hostnames" {
  description = "enables hostnames to be created for public/private ips assigned to instance"
  default = "true"
}

variable "enable_dns_support" {
  description = "enable/disable aws provided DNS server for vpc"
  default = "true"
}
