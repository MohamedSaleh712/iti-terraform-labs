provider "aws" {
  region     = "us-east-1"
}


resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_terraform_vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.RT.id
}

# resource "aws_network_interface" "NIC" {
#   subnet_id   = aws_subnet.subnet.id
#   private_ips = ["10.0.0.10"]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }


resource "aws_instance" "tera_ec2" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.subnet.id
  associate_public_ip_address= true
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
#   network_interface {
#     network_interface_id = aws_network_interface.NIC.id
#     device_index= 0
#   }
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl reload apache2
  EOF
}

resource "aws_security_group" "ec2-sg" {
  name        = "ec2-security-group"

  vpc_id = aws_vpc.main_vpc.id

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
