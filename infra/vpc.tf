locals {
  vpc_cidr        = "10.0.0.0/16"
  public_cidrs    = ["10.0.0.0/24", "10.0.1.0/24"]
  private_cidrs   = ["10.0.10.0/24", "10.0.11.0/24"]
}

resource "aws_vpc" "ecs_poc_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "${var.app_name}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecs_poc_vpc.id
}

resource "aws_subnet" "public" {
  for_each                = toset(local.public_cidrs)
  vpc_id                  = aws_vpc.ecs_poc_vpc.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone_id    = element(data.aws_availability_zones.available.zone_ids, index(local.public_cidrs, each.value))
  tags = { Name = "${var.app_name}-public-${index(local.public_cidrs, each.value)}" }
}

resource "aws_subnet" "private" {
  for_each             = toset(local.private_cidrs)
  vpc_id               = aws_vpc.ecs_poc_vpc.id
  cidr_block           = each.value
  map_public_ip_on_launch = false
  availability_zone_id = element(data.aws_availability_zones.available.zone_ids, index(local.private_cidrs, each.value))
  tags = { Name = "${var.app_name}-private-${index(local.private_cidrs, each.value)}" }
}

data "aws_availability_zones" "available" {}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_poc_vpc.id
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id 
    }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ecs_poc_vpc.id
}
resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}