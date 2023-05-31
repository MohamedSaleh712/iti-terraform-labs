resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.gateway_id
      nat_gateway_id = var.nat_gateway_id
  }
}

resource "aws_route_table_association" "route_table_association" {
  # count = length(var.subnet_id)
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.route_table.id
  # gateway_id = var.gateway_id
}