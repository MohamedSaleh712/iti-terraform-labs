# output "public-ip" {
#   value = aws_instance.lab2-ec2[keys(aws_instance.lab2-ec2)[0]].public_ip

# }

# output "private-ip-1" {
#   value = aws_instance.lab2-ec2[keys(aws_instance.lab2-ec2)[0]].private_ip
# }

# output "private-ip-2" {
#   value = aws_instance.lab2-ec2[keys(aws_instance.lab2-ec2)[1]].private_ip
# }

output "ips" {
  value = tomap({
    for k, server in aws_instance.lab2-ec2 : k => [server.private_ip,server.public_ip]

  })
} 