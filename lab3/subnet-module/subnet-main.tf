resource "aws_subnet" "subnet" {
    vpc_id= var.vpc_id
    cidr_block = var.subnet-cidr-blocks
    availability_zone =var.subnet-AZ
    tags = {
        Name = var.subnet-name
     }
}