# LOAD BALANCER ~ TERRAFORM

Bem vindos ao código para provisionamento de um ALB e seus componentes via terraform :)

Neste diretório vocês acharão 4 diretórios, cada diretório com um módulo e com uma arquitetura diferente.

**_Caso de uso_**: 

1: **_`listener-rule-443+target-group`_** - Código IaC responsável pela criação de todos os elementos abaixo: listener, listener rule na porta 443 (dns integration via http header) e também um target group atachado de forma automática em um ALB existente e também no forward do listener. 

2: **_`load-balancer-all-resources`_** - Código IaC responsável pela criação de todos os componentes de uma vez, ótimo para utilização quando precisa criar do zero todos os recursos. Sobe então neste módulo: Application load balancer, listener rule (80 e 443), rules de dns integration (http_header) na porta 443, security group com regras default, target group e também o redirect na porta 80.

3: **_`load-balancer+listener-rule-80+redirect`_** - Código IaC responsável pela criaçao de um application load balancer, listener, listener rule na porta 80, security group com regras default e também um redirect para a porta 443.

4: **_`nlb+listener-rule-443+target-group`_** - Código IaC responsável pela criaçao de um network load balancer, listener + listener rule na porta 443, gerando comunicação com a criação do target group e também atachando em um ALB existente (conta local). Lembrando que esse recurso será criado para se comunicar com um API Gateway existente.

**_Importante:_** A documentação da haschicorp é bem completa, se quiserem dar uma olhada, segue o link do glossário com todos os recursos do terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Para executar esse módulo você precisará: 

| Name | Version|
|------|--------|
| aws | 3.* |
| terraform | 0.15.*| 
| github | 3.3.*

## Espero que seja útil a todos!!!!! Grande abraço <3

**_Importante:_** Qualquer dificuldade encontrada, melhoria ou se precisarem alterar alguma linha de código, só entrar em contato que te ajudo <3