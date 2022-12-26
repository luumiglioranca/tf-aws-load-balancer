
############################################################################################
#                                                                                          #
#                         CRIAÇÃO DO NOSSO ALB MONSTRUOSO E LINDO                          #
#                                                                                          # 
############################################################################################

resource "aws_lb" "application_load_balancer" {
  name               = "alb-${var.alb_name}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  # If true, deletion of the load balancer will be disabled via the AWS API.
  # Defaults to false
  
  enable_deletion_protection = var.deletion_protection

  tags = {
    Cliente  = "${var.cliente_value}"
    Area     = "${var.area_value}"
    SubArea  = "${var.sub_area_value}"
    Ambiente = "${var.ambiente}"
  }
}

############################################################################################
#                                                                                          #
#                         CRIAÇÃO DO TARGET GROUP PARA O LOAD BALANCER                     #
#                                                                                          # 
############################################################################################

resource "aws_lb_target_group" "tg_application_load_balancer" {
  name     = "tg-${var.alb_name}"
  port     = var.target_group_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  health_check {

    healthy_threshold   = var.healthy_threshold 
    interval            = var.health_check_interval
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.unhealthy_threshold
  }

  tags = {
    Cliente  = "${var.cliente_value}"
    Area     = "${var.area_value}"
    SubArea  = "${var.sub_area_value}"
    Ambiente = "${var.ambiente}"
  }
}

############################################################################################
#                                                                                          #
#                         LISTENER PORTA 80 - PROTOCOLO HTTP <3                            #
#                                                                                          # 
############################################################################################

resource "aws_lb_listener" "listener_application_load_balancer" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_application_load_balancer.arn
  }
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.listener_application_load_balancer.arn

  action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  /*
  condition {
    http_header {
      http_header_name = "Strict-Transport-Security"
      values           = ["max-age=31536000; includeSubdomains"]
    }
  }

condition {
    http_header {
      http_header_name = "Referrer-Policy"
      values           = ["origin-when-cross-origin"]
    }
  }

condition {
    http_header {
      http_header_name = "X-Content-Type-Options"
      values           = ["nosniff"]
    }
  }

condition {
    http_header {
      http_header_name = "X-Frame-Options"
      values           = ["SAMEORIGIN"]
    }
  }
*/
}

############################################################################################
#                                                                                          #
#                    LISTENER PORTA 443 - PROTOCOLO HTTPS + SSL CERTIFICATE <3             #
#                                                                                          # 
############################################################################################

resource "aws_lb_listener" "listener_433_ssl" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_alb_policy

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_application_load_balancer.arn
  }
}