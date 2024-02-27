############################################################################################
#                                                                                          #
#                       MÓDULO PARA CRIAÇÃO DO LOAD BALANCER FULL :)                       #
#                                                                                          #
############################################################################################

module "load_balancer" {
  source = "git@github.com:luumiglioranca/tf-aws-load-balancer.git//load-balancer-full/resource"

  port     = "443"
  name     = local.resource_name
  internal = "true"
  vpc_id   = data.aws_vpc.selected.id
  protocol = "HTTPS"

  load_balancing_settings = [{
    name               = "${local.alb_name}"
    internal           = "${local.alb_internal}"
    load_balancer_type = "${local.alb_type}"
    security_groups    = [module.alb_security_group.security_group_id]
    #subnets            = [local.subnets]

    subnets = [
      data.aws_subnet.priv_1a.id,
      data.aws_subnet.priv_1b.id,
    ]
  }]

  target_group_settings = [{
    name            = "tg-${each.value}"
    target_port     = "${local.container_port}"
    target_protocol = "${local.http_protocol}"
    target_type     = "${local.target_type}"
    vpc_id          = data.aws_vpc.main.id

    health_check = {
      healthy_threshold   = "${local.healthy_threshold}"
      unhealthy_threshold = "${local.unhealthy_threshold}"
      timeout             = "${local.timeout}"
      interval            = "${local.interval}"
      path                = "${local.health_check_path}"
      #health_check_port   = "${local.container_port}"
      protocol            = "${local.http_protocol}"
      matcher             = "${local.matcher}"
    }
  }]

  load_balancing_listener_http = [{
    port     = "${local.http_port}"
    protocol = "${local.http_protocol}"
  }]

  load_balancing_listener_https = [{
    port            = "${local.https_port}"
    protocol        = "${local.https_protocol}"
    ssl_policy      = "${local.ssl_policy}"
    certificate_arn = data.aws_acm_certificate.domain_ssl.arn
  }]

    service_load_balancing_https = [{
    
    priority_rule = "${local.priority_rule}"

    redirect_rule = {
      type = "${local.rule_type}"

      redirect = {
        port        = "${local.https_port}"
        protocol    = "${local.https_protocol}"
        status_code = "${local.status_code}"
      }
    }

    condition = {
      path_pattern = {
        values = ["/*"]
      }
    }
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
        certificate_arn = data.aws_acm_certificate.domain_ssl.arn
        ssl_policy      = "ELBSecurityPolicy-2016-08"
      }
    }

    condition = {
      path_pattern = {
        values = ["/*"]
      }
    }
  }]

    host_header_listener_rule = [{
    action = {
      type = "forward"
      #target_group_arn = "${local.load_balancer_arn}"
    }

    condition = {
      host_header = {
        values = ["${local.alb_name}.${local.domain_name}"]
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