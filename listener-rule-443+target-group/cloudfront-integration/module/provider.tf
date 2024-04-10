##################################################################################################
#                                                                                                #
#                                      VARIÁVEIS DE AMBIENTE <3                                  #
#                                                                                                #
##################################################################################################

locals {
  alb_name    = ""
  vpc_id      = ""
  account_id  = ""
  domain_name = ""
  cidr_blocks = ""

  /* CONFIGURAÇÕES DO CONTAINER */
  container_port     = ""
  availability_zones = ""

  /* CONFIGURAÇÕES DO LOAD BALANCER & HEALTH CHECK (TARGET GROUP) */
  health_check_path = ""
  alb_internal      = ""

  default_tags = {
    Area     = ""
    Ambiente = ""
    SubArea  = ""
  }

  # VARIÁVEIS GLOBAIS [PADRONIZADAS] - OBS: NÃO SE FAZ NECESSÁRIO REALIZAR A TROCA DE NENHUMA VARIÁVEL DESTE BLOCO !!!
  region                             = "us-east-1"
  cloudwatch_retention               = "14"
  launch_type                        = "EC2"
  network_mode                       = "bridge"
  https_protocol                     = "HTTPS"
  target_type                        = "instance"
  alb_type                           = "application"
  healthy_threshold                  = "3"
  interval                           = "300"
  http_protocol                      = "HTTP"
  matcher                            = "200,301,302"
  timeout                            = "60"
  http_port                          = "80"
  https_port                         = "443"
  unhealthy_threshold                = "2"
  load_balancer_port                 = "443"
  target_group_port                  = "80"
  ssl_policy                         = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  deployment_minimum_healthy_percent = "100"

  # CONFIGURAÇÕES INGRESS RULE - SECURITY GROUP*/
  description         = "Acesso Interno"
  from_port           = "0"
  to_port             = "65535"
  protocol            = "tcp"
  security_group_type = "ingress"
  tcp_protocol        = "tcp"
}

########################################################################################################
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
