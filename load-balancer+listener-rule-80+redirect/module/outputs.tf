##############################################################################################
#                                                                                            #
#                             OUTPUT APPLICATION LOAD BALANCER (ALB) :)                      #
#                                                                                            #
##############################################################################################

output "dns_alb" {
  value = aws_route53_record.application_load_balancer_dns.name
}

output "load_balancer_arn" {
  value = [module.application_load_balancer.arn]
}