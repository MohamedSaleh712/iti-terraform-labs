output "Pub_instances_ids" {
  value       = aws_instance.nginx-instance-proxy[*].id
}

output "Private_instances_ids" {
  value       = aws_instance.apache-instance2[*].id
}