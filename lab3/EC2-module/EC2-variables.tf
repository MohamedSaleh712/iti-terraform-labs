variable "ec2_type" {
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  default     = "my-keypair"
}

variable "vpc_id" {
  type        = string
}

variable "private_lb_dns" {
  
}

variable "my_subnets_ids" {
  type        = list(string)
}