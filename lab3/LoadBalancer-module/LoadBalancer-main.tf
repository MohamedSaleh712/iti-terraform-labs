
resource "aws_lb" "aws_LoadBalancer" {
    count              = 2
    name               = count.index == 0 ? "Public-LB" : "Private-LB" 
    internal           = count.index == 0 ? false : true
    load_balancer_type = "application"
    subnets            = count.index == 0 ? [var.my_subnets_ids[count.index], var.my_subnets_ids[count.index+1]] : [var.my_subnets_ids[count.index+1], var.my_subnets_ids[count.index+2]]
    security_groups    = [aws_security_group.allow_LoadBalancer.id]
}

resource "aws_lb_listener" "listeners" {
    count = 2
    load_balancer_arn = aws_lb.aws_LoadBalancer[count.index].arn
    port              = var.listen_port
    protocol          = var.listen_protocol

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.alb_target_group[count.index].arn
    }
}

resource "aws_lb_target_group" "alb_target_group" {
    count       = 2
    name        = count.index == 0 ? "Public-TG" : "Private-TG"
    port        = var.listen_port
    protocol    = var.listen_protocol
    vpc_id      = var.vpc_id # ------------------------- input here
    target_type = "instance"

    health_check {
        path = "/"
    }
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_public" {
    count = length(var.Public_instances)
    target_group_arn = aws_lb_target_group.alb_target_group[0].arn
    target_id        = var.Public_instances[count.index]
    port             = var.listen_port
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_private" {
    count = length(var.Private_instances)
    target_group_arn = aws_lb_target_group.alb_target_group[1].arn
    target_id        = var.Private_instances[count.index]
    port             = var.listen_port
}

resource "aws_security_group" "allow_LoadBalancer" {
  name        = "allow_traffic_http_ssh"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

# resource "aws_lb" "aws_LoadBalancer" {
#   name               = var.LoadBalancer-name
#   internal           = var.internal
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.allow_LoadBalancer.id]
# #   subnets            = [for subnet in aws_subnet.public : subnet.id]
#   subnets            = var.subnet_id

# }

# resource "aws_lb_target_group" "alb_target_group" {
#   port     = 80
#   target_type = "instance"
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
# }

# resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
#   target_group_arn = var.aws_lb_target_group_attachment_arn
#   target_id        = var.instance_id
#   port             = 80
# }