#################################################################################################
#                                                                                                #
#                                      VARIÁVEIS DE AMBIENTE <3                                  #
#                                                                                                #
##################################################################################################

locals {
  alb_name     = ""
  alb_internal = ""
  vpc_id       = ""
  account_id   = ""
  #subnets      = ["subnet-0a57763c40d757152", "subnet-0801fdff20634df95"]

  /* CONFIGURAÇÕES DO CONTAINER */
  container_port     = ""
  availability_zones = ""
  load_balancer_arn  = ""

  /* CONFIGURAÇÕES DO LOAD BALANCER & HEALTH CHECK (TARGET GROUP) */
  health_check_path = ""
  
  default_tags = {
    Area     = ""
    Ambiente = ""
    SubArea  = ""
  }

  # VARIÁVEIS GLOBAIS [PADRONIZADAS] - OBS: NÃO SE FAZ NECESSÁRIO REALIZAR A TROCA DE NENHUMA VARIÁVEL DESTE BLOCO !!!
  domain_name                        = "edtech.com.br"
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
  priority_rule                      = "1"
  rule_type                          = "redirect"
  status_code                        = "HTTP_301"

  # CONFIGURAÇÕES INGRESS RULE - SECURITY GROUP*/
  description         = "Acesso Interno - VPC HUB"
  from_port           = "0"
  to_port             = "65535"
  protocol            = "tcp"
  security_group_type = "ingress"
  tcp_protocol        = "tcp"
  cidr_blocks         = "10.107.40.0/22"
}

##################################################################################################
#                                                                                                #
#                        PROVIDER AWS + ROLE ATLANTIS + TFSTATE FILE - S3 BUCKET                 #
#                                                                                                #
##################################################################################################

provider "aws" {
  region = local.region
  #profile = "ops-payer"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/AtlantisRole"
    #role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "atena"
  region = local.region
  #profile = "atena"
}

terraform {
  backend "s3" {
    role_arn = "arn:aws:iam::424747098912:role/AtlantisRole"
    #profile                     = "ops-payer"
    bucket                      = "s3-compasso-uol-424747098912-tfstate"
    key                         = ""
    region                      = "us-east-1"
    encrypt                     = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}