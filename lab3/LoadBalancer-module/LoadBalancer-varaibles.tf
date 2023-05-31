variable "my_subnets_ids" {
    type = list(string)
}

variable "listen_port" {
    type = number
    default = 80
}

variable "listen_protocol" {
    type = string
    default = "HTTP"
}

variable "Public_instances" {
    type = list
}

variable "Private_instances" {
    type = list
}

variable "vpc_id" {
    type = string
}


# variable "LoadBalancer-name" {
  
# }

# variable "internal" {
#   default = false
# }

# variable "vpc_id" {
  
# }

# # variable "vpc_cidr_block" {
  
# # }

# variable "subnet_id" {
  
# }

# variable "aws_lb_target_group_attachment_arn" {
  
# }

# variable "instance_id" {
  
# }