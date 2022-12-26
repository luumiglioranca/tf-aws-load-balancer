output "dns_name" {
    value   = aws_lb.application_load_balancer.dns_name
}
output "tg_arn" {
    value   = aws_lb_target_group.tg_application_load_balancer.arn
}