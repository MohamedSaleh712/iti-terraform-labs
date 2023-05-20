variable "vpc-cidr" {
  description = "this variable contain vpc cidr of lab-2"
  type        = string
}

variable "vpc-name" {
  type = string
}

variable "subnet-cidr" {
  type = list(string)
}

variable "subnet-name" {
  type = string
}

variable "route-table-cidr" {
  type = string
}

variable "ec2-spef" {
  type = map(any)
}