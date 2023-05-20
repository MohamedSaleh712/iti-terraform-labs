resource "aws_vpc" "lab2_vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "lab2_subnet" {
  vpc_id     = aws_vpc.lab2_vpc.id
  count      = length(var.subnet-cidr)
  cidr_block = var.subnet-cidr[count.index]
  tags = {
    Name = var.subnet-name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab2_vpc.id
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.lab2_vpc.id
  route {
    cidr_block = var.route-table-cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  depends_on = [aws_subnet.lab2_subnet]
}

resource "aws_eip" "ElasticIP" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.ElasticIP.id
  subnet_id     = aws_subnet.lab2_subnet[0].id
  depends_on = [aws_subnet.lab2_subnet,
    aws_internet_gateway.igw,
  aws_eip.ElasticIP]
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.lab2_vpc.id
  route {
    cidr_block     = var.route-table-cidr
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  depends_on = [aws_subnet.lab2_subnet]
}

resource "aws_route_table_association" "RTA-public" {
  subnet_id      = aws_subnet.lab2_subnet[0].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "RTA-private" {
  subnet_id      = aws_subnet.lab2_subnet[1].id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_instance" "lab2-ec2" {
  ami                    = var.ec2-spef["ami"]
  instance_type          = var.ec2-spef["instance_type"]
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  for_each = {
    "ec2-1" = { subnet_id = aws_subnet.lab2_subnet[0].id,
    associate_public_ip_address = true }
    "ec2-2" = { subnet_id = aws_subnet.lab2_subnet[1].id,
    associate_public_ip_address = false }
  }

  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.associate_public_ip_address


  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl reload apache2
  EOF
}

resource "aws_security_group" "ec2-sg" {
  name = "ec2-security-group"

  vpc_id = aws_vpc.lab2_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


