############################################################################################
#                                                                                          #
#                         MÓDULO PARA CRIAÇÃO DO LOAD BALANCER  :)                         #
#                                                                                          #
############################################################################################

module "application_load_balancer" {
  source = "git@github.com:luumiglioranca/tf-aws-load-balancer.git//load-balancer-only/resource"

  load_balancing_settings = [{
    name                       = "${local.back_campus_digital_name}"
    internal                   = "${local.alb_internal}"
    load_balancer_type         = "${local.alb_type}"
    target_protocol            = "${local.http_protocol}"
    target_type                = "${local.target_type}"
    port                       = "${local.container_port}"
    target_port                = "${local.target_group_port}"
    protocol                   = "${local.https_protocol}"
    ssl_policy                 = "${local.ssl_policy}"
    enable_deletion_protection = "false"
    security_groups            = [module.back_campus_digital_sg.security_group_id]
    vpc_id                     = data.aws_vpc.main.id
    certificate_arn            = data.aws_acm_certificate.edtech_ssl.arn

    subnets = [
      data.aws_subnet.priv_1a.id,
      data.aws_subnet.priv_1b.id,
    ]
  }]

  target_group_settings = [{
    name            = "tg-${local.resource_name}"
    target_port     = "3333"
    target_protocol = "HTTP"
    target_type     = "instance"
    vpc_id          = data.aws_vpc.selected.id

    health_check = {
      healthy_threshold   = "3"
      interval            = "300"
      protocol            = "HTTP"
      matcher             = "200,301,302"
      timeout             = "60"
      path                = "/api/healthcheck"
      unhealthy_threshold = "2"
    }
  }]

  load_balancing_listener_http = [{
    port     = "80"
    protocol = "HTTP"
  }]

  load_balancing_listener_https = [{
    port            = "443"
    protocol        = "HTTPS"
    certificate_arn = data.aws_acm_certificate.edtech_ssl.arn
    ssl_policy      = "ELBSecurityPolicy-2016-08"
  }]

  default_tags = local.default_tags

  listener_rule = [{

    priority_rule = "1"

    redirect_rule = {
      type = "redirect"

      redirect = {
        port            = "443"
        protocol        = "HTTPS"
        status_code     = "HTTP_301"
        certificate_arn = data.aws_acm_certificate.edtech_ssl.arn
        ssl_policy      = "ELBSecurityPolicy-2016-08"
      }
    }

    condition = {
      path_pattern = {
        values = ["/*"]
      }
    }
  }]
}

############################################################################################
#                                                                                          #
#                         MÓDULO PARA CRIAÇÃO DO SECURITY GROUP :)                         #
#                                                                                          #
############################################################################################

module "alb_security_group" {
  source = "https://github.com/luumiglioranca/tf-aws-security-group.git//resource"

  description         = "Security Group para o ${local.alb_name} :)"
  security_group_name = "${local.alb_name}-sg"
  vpc_id              = data.aws_vpc.main.id

  ingress_rule = [
    {
      description = "ECS Acesso interno"
      type        = "ingress"
      from_port   = "0"
      to_port     = "65535"
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.main.cidr_block]
    }
  ]

  default_tags = merge({

    Name = "sg-${local.alb_name}"

    }
  )
}