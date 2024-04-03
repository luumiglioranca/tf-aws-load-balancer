#########################################################################################################
#                                                                                                       #
#                       Data Source - VPC + Subnets Private/Publica + Certificado SSL ...               #
#                                                                                                       #
#########################################################################################################

# Encontrando o VPC ID 
data "aws_vpc" "main" {
  id = local.vpc_id
}

# Encontrando o ID das subnets privadas
data "aws_subnet" "priv_1a" {
  vpc_id = local.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*Priv-1a*"]
  }
}

data "aws_subnet" "priv_1b" {
  vpc_id = local.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*Priv-1b*"]
  }
}

# Encontrando o nosso domínio no certificado SSL (ACM)
data "aws_acm_certificate" "domain_ssl" {

  domain   = "*.${local.domain_name}"
  statuses = ["ISSUED"]
}

#Encontrando o nome do API GTW criado anteriormente :)
data "aws_api_gateway_rest_api" "main" {
  name = local.api_gateway_name
}