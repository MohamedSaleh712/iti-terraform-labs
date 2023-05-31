resource "aws_vpc" "vpc" {
    cidr_block = var.vpc-cidr
    tags = {
      Name= var.vpc-name
    }
}

resource "aws_internet_gateway" "ign" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name= var.igw-name
    }
}