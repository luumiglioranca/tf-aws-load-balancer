##################################################################################################
#                                                                                                #
#                                      VARIÁVEIS DE AMBIENTE <3                                  #
#                                                                                                #
##################################################################################################

locals {
  api_gateway_name         = ""
  vpc_id                   = ""
  account_id               = ""
  alb_arn_to_nlb_listener  = ""
  domain_name              = ""

  /* CONFIGURAÇÕES DO LOAD BALANCER & HEALTH CHECK (TARGET GROUP) */
  health_check_path = ""
  container_port    = ""

  default_tags = {
    Area     = ""
    Ambiente = ""
  }

  # VARIÁVEIS GLOBAIS [PADRONIZADAS] - OBS: NÃO SE FAZ NECESSÁRIO REALIZAR A TROCA DE NENHUMA VARIÁVEL DESTE BLOCO !!!
  alb_name              = "nlb-${data.aws_api_gateway_rest_api.main.name}"
  target_group_protocol = "TCP"
  target_group_port     = "443"
  target_type           = "alb"
  alb_type              = "network"
  alb_internal          = "true"
  region                = "us-east-1"
  load_balancer_arn     = module.network_load_balancer.alb_arn
  https_port            = "443"

  # VARIÁVEIS DO TARGET GROUP (NÃO MUDAR)
  healthy_threshold   = "3"
  unhealthy_threshold = "2"
  timeout             = "60"
  interval            = "300"
  http_protocol       = "HTTP"
  matcher             = "200,301,302"

  # CONFIGURAÇÕES INGRESS RULE - SECURITY GROUP*/
  description         = "Acesso Interno"
  from_port           = "0"
  to_port             = "65535"
  protocol            = "tcp"
  security_group_type = "ingress"
  tcp_protocol        = "tcp"
}


#######################################################################################################
#                                                                                                      #
#                                     CONNECT PROVIDER - AWS    :)                                     #
#                                                                                                      #
########################################################################################################

provider "aws" {
  #Região onde será configurado seu recurso. Deixei us-east-1 como default
  region = "us-east-1"

  #Conta mãe que será responsável pelo provisionamento do recurso.
  profile = ""

  #Assume Role necessária para o provisionamento de recurso, caso seja via role.
  assume_role {
    role_arn = "" #Role que será assumida pela sua conta principal :)
  }
}

#Configurações de backend, neste caso para armazenar o estado do recurso via Bucket S3.
terraform {
  backend "s3" {
    #Profile (conta) de onde está o bucket que você irá armazenar seu tfstate 
    profile = ""

    #Nome do Bucket
    bucket = ""

    #Caminho da chave para o recurso que será criado
    key = "caminho-da-chave/exemplo/terraform.tfstate"

    #Região onde será configurado seu recurso. Deixei us-east-1 como default
    region = "us-east-1"

    #Valores de segurança. Encriptação, Validação de credenciais e Check da API.
    encrypt                     = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
