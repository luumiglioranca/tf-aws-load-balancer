############################################################################################
#                                                                                          #
#                                 OUTPUT NETWORK LOAD BALANCER :)                          #
#                                                                                          #
############################################################################################

output "network_load_balancer_dns_name" {
  value = aws_route53_record.main.name
}

output "network_load_balancer_arn" {
  value = [module.network_load_balancer.arn]
}

output "vpc_link_id" {
  value = [module.network_load_balancer.vpc_link_id]
}