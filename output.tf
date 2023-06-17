output "listener_arn"{
    value=aws_lb_listener.lb-listener
}

output "alb"{
    value=aws_lb.main-lb
}
