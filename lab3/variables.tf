variable "region" {
  type = string
}

variable "s3-remote-state-bucket-name" {
  type = string
}

variable "vpc-cidr" {

}

variable "vpc-name" {

}

variable "igw-name" {

}

variable "subnets" {
  type = map(tuple([string, string]))
}

# variable "subnet_ids" {
#   default = ""
# }

# variable "LoadBalancer" {
  
# }