resource "aws_nat_gateway" "NAT-gateway" {
  subnet_id= module.subnet-caller["public_subnet_1"].subnet-id-output
  allocation_id=aws_eip.ElasticIP.allocation_id
}

resource "aws_eip" "ElasticIP" {
  vpc = true
}