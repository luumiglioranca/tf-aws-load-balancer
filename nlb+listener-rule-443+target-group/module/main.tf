############################################################################################
#                                                                                          #
#                       MÓDULO PARA CRIAÇÃO DO NETWORK LOAD BALANCER  :)                   #
#                                                                                          #
############################################################################################

module "network_load_balancer" {
  source = "git@github.com:luumiglioranca/tf-aws-load-balancer.git//nlb+listener-rule-443+target-group/resource"

  alb_arn_to_nlb_listener = local.alb_arn_to_nlb_listener

  load_balancing_settings = [{
    name               = "${local.alb_name}"
    internal           = "${local.alb_internal}"
    load_balancer_type = "${local.alb_type}"
    security_groups    = [module.alb_security_group.security_group_id]

    subnets = [
      data.aws_subnet.priv_1a.id,
      data.aws_subnet.priv_1b.id,
    ]
  }]

  target_group_settings = [{
    name            = "tg-${local.alb_name}"
    target_port     = "${local.target_group_port}"
    target_protocol = "${local.target_group_protocol}"
    target_type     = "${local.target_type}"
    vpc_id          = data.aws_vpc.main.id

    health_check = {
      healthy_threshold   = "${local.healthy_threshold}"
      unhealthy_threshold = "${local.unhealthy_threshold}"
      timeout             = "${local.timeout}"
      interval            = "${local.interval}"
      path                = "${local.health_check_path}"
      health_check_port   = "${local.container_port}"
      protocol            = "${local.http_protocol}"
      matcher             = "${local.matcher}"
    }
  }]

  load_balancing_listener_https = [{
    port     = "${local.https_port}"
    protocol = "TCP"

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
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.main.cidr_block]
    }
  ]

  default_tags = merge({

    Name = "sg-${local.alb_name}"

    },
  )
}