resource "aws_security_group" "vpce_sg" {
  name   = "${var.app_name}-vpce"
  vpc_id = aws_vpc.ecs_poc_vpc.id
  ingress { 
    from_port = 443 
    to_port = 443 
    protocol = "tcp" 
    cidr_blocks = [aws_vpc.ecs_poc_vpc.cidr_block] 
  }
  egress  { 
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# Gateway endpoints
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.ecs_poc_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.ecs_poc_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
}

# Interface endpoints (enable private_dns so AWS SDKs resolve *.amazonaws.com to the VPC endpoints)
locals {
  interface_services = [
    "ecr.api",
    "ecr.dkr",
    "logs",
    "secretsmanager",
    "sts"
  ]
}

resource "aws_vpc_endpoint" "interfaces" {
  for_each               = toset(local.interface_services)
  vpc_id                 = aws_vpc.ecs_poc_vpc.id
  service_name           = "com.amazonaws.${var.aws_region}.${each.value}"
  vpc_endpoint_type      = "Interface"
  private_dns_enabled    = true
  security_group_ids     = [aws_security_group.vpce_sg.id]
  subnet_ids             = [for s in aws_subnet.private : s.id]
}
