resource "aws_instance" "nginx-instance-proxy" {
    count = 2
    ami = "ami-007855ac798b5175e"
    instance_type = var.ec2_type
    subnet_id = var.my_subnets_ids[count.index]
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    provisioner "local-exec" {
        command = "echo public-ip ${count.index + 1} ${self.public_ip} >> ./IPs.txt"
    }
    connection {
        type     = "ssh"
        private_key = file("./${var.key_name}.pem")
        user     = "ubuntu"
        host     = self.public_ip
     }

    provisioner "remote-exec" {
     inline = [
        
        "sudo apt-get update",
        "sudo apt-get -y install nginx",
        "sudo systemctl start nginx", 
        "sudo systemctl enable nginx", 
        "sudo sed -i '52 i proxy_pass http://${var.private_lb_dns};'  /etc/nginx/sites-available/default",
        "sudo echo \"Hello world $(hostname -f)\" > /var/www/html/index.nginx-debian.html",
        "sudo systemctl restart nginx"
     ] 
    }
    tags = {
        Name="pub-nginx-instance-${count.index + 1}"
    }
}

# ec2 instance - private
resource "aws_instance" "apache-instance2" {
    count = 2
    ami = "ami-007855ac798b5175e"
    instance_type = var.ec2_type
    subnet_id = var.my_subnets_ids[count.index + 2]
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
    provisioner "local-exec" {
        command = "echo private-ip ${count.index + 2} ${self.private_ip} >> ./all-ips.txt"
    }

    user_data = <<-EOF
        #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl restart apache2
    EOF
    
    tags = {
        Name="private-apache-instance-${count.index + 1}"
    }
}


resource "aws_security_group" "allow_http_ssh" {
  description = "Allow http and ssh inbound traffic"
  vpc_id = var.vpc_id
  tags = {
    Name = "my-security-group"
  }
 
    ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}