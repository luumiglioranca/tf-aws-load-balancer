# AWS Terraform - Load Balancer
Este módulo irá provisionar os seguintes recursos:

1: [Application Load Balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

2: [Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

3: [Security Group Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)

**_Importante:_** A documentação da haschicorp é bem completa, se quiserem dar uma olhada, segue o link do glossário com todos os recursos do terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Exemplo de um module pré-configurado :)
`Caso de uso`: Exemplo de module ALB portas 80 & 443 + Redirect + Certificate + SSL Policy

```bash

module "load_balancer" {
  source = "git@github.com:uoledtech-opm/tf-aws-load-balancer.git//load-balancer-only"

load_balancing_settings = [{
    name                       = "${local.alb_name}"
    internal                   = "${local.alb_internal}"
    load_balancer_type         = "${local.alb_type}"
    target_protocol            = "${local.http_protocol}"
    target_type                = "${local.target_type}"
    port                       = "${local.container_port}"
    target_port                = "${local.target_group_port}"
    protocol                   = "${local.https_protocol}"
    ssl_policy                 = "${local.ssl_policy}"
    security_groups            = [module.alb_security_group.security_group_id]
    vpc_id                     = data.aws_vpc.main.id
    certificate_arn            = data.aws_acm_certificate.edtech_ssl.arn
    enable_deletion_protection = "false"

    subnets = [
      data.aws_subnet.priv_1a.id,
      data.aws_subnet.priv_1b.id,
    ]
  }]
}

module "security_group" {
  source = "git@github.com:uoledtech-opm/tf-aws-security-group.git"

  description         = "Security Group para o ${local.resource_name} :)"
  security_group_name = "${local.resource_name}-sg"
  vpc_id              = data.aws_subnet_ids.subnet_priv.id

  ingress_rule = [
    {
      description = "Acesso Interno - VPC Local"
      type        = "ingress"
      from_port   = "0"
      to_port     = "65535"
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
    },
    {
      description = "Acesso Interno - Proxy Hub"
      type        = "ingress"
      from_port   = "0"
      to_port     = "65535"
      protocol    = "tcp"
      cidr_blocks = ["10.107.40.0/22"]
    }
  ]

  default_tags = merge({

    Name = "sg-${local.resource_name}"

    },

  local.default_tags)
}

```

## Para executar esse módulo você precisará: 

| Name | Version|
|------|--------|
| aws | 3.* |
| terraform | 0.15.*| 
| github | 3.3.*


## Arquivo de Outputs

| Name | Description |
| ---- | ----------- |
| dns_name | dns que será provisionaodo para o ALB na conta atena|
| arn | arn do target group|


## Espero que seja útil a todos!!!!! Grande abraço <3


**_Importante:_** Qualquer dificuldade encontrada, melhoria ou se precisarem alterar alguma linha de código, entrar em contato com o SRE (Lucas Migliorança) da equipe de OPM.
