#######################################################################################################
#                                                                                                     #
#    MÓDULO PARA CRIAÇÃO DAS REGRAS DE DNS INTEGRATION PARA O LISTENER DO ALB CRIADO ANTERIORMENTE    #                        #
#                                                                                                     #
#######################################################################################################

module "dns_integration" {
  source = "git@github.com:luumiglioranca/tf-aws-load-balancer.git//load-balancer-rules/dns-integration"

  #Se precisar de regras iguais para mais de um DNS, utilizar a condição abaixo
  for_each = toset([
    "teste-1",
    "teste-2",
    "teste-3"
  ])

  port     = local.container_port
  name     = local.alb_name
  internal = local.alb_internal
  vpc_id   = data.aws_vpc.main.id
  protocol = local.https_protocol
  load_balancer_arn = local.load_balancer_arn

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

    #Setar aqui o ARN do seu load balancer
    load_balancer_arn = ""
  }]

  load_balancing_listener_https = [{
    port            = "${local.https_port}"
    protocol        = "${local.https_protocol}"
    certificate_arn = data.aws_acm_certificate.domain_ssl.arn
    ssl_policy      = "${local.ssl_policy}"
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

    default_tags = local.default_tags

}

#################################
#                               #
#      OBSERVAÇÃO IMPORTANTE    #
#                               #
#################################

####################################################################################################################################
# Esse módulo criará a regra no listener do ALB, mas também criará um target group apartado e as regrinhas na porta 80 e porta 443 #
####################################################################################################################################