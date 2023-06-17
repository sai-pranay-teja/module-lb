resource "aws_lb" "main-lb" {
  name               = "${var.env}-${var.name}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.lb-traffic.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection


  tags = {
    Name = "${var.env}-${var.name}-lb"
  }
}


resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.main-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/html"
            message_body = "<h1>503 - Invalid Request</h1>"
            status_code  = "503"
    }
  
  }
}

resource "aws_security_group" "lb-traffic" {
  name        = "${var.env}-${var.name}-lb-SG"
  description = "lb traffic"
  vpc_id=var.vpc_id


  ingress {
    description      = "Load balancer Traffic"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.allow_subnets
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-${var.name} LB traffic"
  }
}