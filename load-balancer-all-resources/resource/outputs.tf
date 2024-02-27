output "alb_name" {
  value = aws_lb.main.0.dns_name
}

output "alb_arn" {
  value = aws_lb.main.0.arn
}

output "arn" {
  value = aws_lb_target_group.main.0.arn
}