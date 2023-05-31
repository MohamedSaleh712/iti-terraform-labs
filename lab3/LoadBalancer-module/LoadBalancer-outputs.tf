output "public_lb_dns" {
    value = aws_lb.aws_LoadBalancer[0].dns_name
}

output "private_lb_dns" {
    value = aws_lb.aws_LoadBalancer[1].dns_name
}