#############################################################################
#                                                                           #
#                     Route53 - APPLICATION LOAD BALANCER (ALB)             #
#                                                                           #
#############################################################################

data "aws_route53_zone" "dns_zone" {
  provider     = aws.sua_conta
  name         = local.domain_name
  private_zone = "false"
}

resource "aws_route53_record" "application_load_balancer_dns" {
  provider = aws.atena
  zone_id = data.aws_route53_zone.dns_zone.zone_id

  name    = "${local.dns_name}.${local.domain_name}"
  type    = "CNAME"
  ttl     = "10"
  records = [module.application_load_balancer.dns_name]
}
