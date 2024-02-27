############################################################################################
#                                                                                          #
#                              OUTPUT APPLICATION LOAD BALANCER :)                         #
#                                                                                          #
############################################################################################

output "application_load_balancer_dns_name" {
  value = aws_route53_record.main.name
}
output "application_load_balancer_arn" {
  value = [module.application_load_balancer.arn]
}
