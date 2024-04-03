############################################################################################
#                                                                                          #
#                         MÓDULO PARA CRIAÇÃO DO LOAD BALANCER  :)                         #
#                                                                                          #
############################################################################################

module "application_load_balancer" {
  source = "git@github.com:luumiglioranca/tf-aws-load-balancer.git//load-balancer+listener-rule-80+redirect/resource"

load_balancing_settings = [{
    name               = "${local.alb_name}"
    internal           = "${local.alb_internal}"
    load_balancer_type = "${local.alb_type}"
    security_groups    = [module.alb_security_group.security_group_id]
    #subnets            = [local.subnets]

    subnets = [
      data.aws_subnet.priv_1a.id,
      data.aws_subnet.priv_1b.id,
      #data.aws_subnet.priv_1c.id
    ]
  }]

  load_balancing_listener_http = [{
    port     = "${local.http_port}"
    protocol = "${local.http_protocol}"
  }]

  service_load_balancing_https = [{

    priority_rule = "${local.priority_rule}"

    redirect_rule = {
      type = "${local.redirect_rule_type}"

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