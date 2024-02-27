#########################################################################################
#                                                                                       #                                 
#                            LOAD BALANCER LISTENER - HTTPS PORT                        #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb_listener" "listerner_https" {
  count = var.create && var.load_balancer_type == "application" ? length(var.load_balancing_listener_https) : 0
  
  load_balancer_arn  = var.load_balancer_arn
  port              = lookup(var.load_balancing_listener_https[count.index], "port", null)
  protocol          = lookup(var.load_balancing_listener_https[count.index], "protocol", null)
  certificate_arn   = lookup(var.load_balancing_listener_https[count.index], "certificate_arn", null)
  ssl_policy        = lookup(var.load_balancing_listener_https[count.index], "ssl_policy", null)

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Unauthorized"
      status_code  = "401"
    }
  }
}

#########################################################################################
#                                                                                       #                                 
#                  LOAD BALANCER HTTPS LISTENER RULE (443) - HOST HEADER                #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb_listener_rule" "listener_https" {
  count = var.create ? length(var.host_header_listener_rule) : 0

  listener_arn = aws_lb_listener.listerner_https.0.arn

  dynamic "action" {
    for_each = length(keys(lookup(var.host_header_listener_rule[count.index], "action", {}))) == 0 ? [] : [lookup(var.host_header_listener_rule[count.index], "action", {})]

    content {
      type = lookup(action.value, "type", null)
      #target_group_arn = lookup(action.value, "target_group_arn", null)
      target_group_arn = aws_lb_target_group.main.0.arn
    }
  }

  dynamic "condition" {
    for_each = length(keys(lookup(var.host_header_listener_rule[count.index], "condition", {}))) == 0 ? [] : [lookup(var.host_header_listener_rule[count.index], "condition", {})]

    content {
      dynamic "host_header" {
        for_each = length(keys(lookup(condition.value, "host_header", {}))) == 0 ? [] : [lookup(condition.value, "host_header", {})]
        content {
          values = lookup(host_header.value, "values", null)
        }
      }
    }
  }
}


#########################################################################################
#                                                                                       #                                 
#                                LOAD BALANCER TARGET GROUP                             #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb_target_group" "main" {
  count = var.create ? length(var.target_group_settings) : 0

  name        = lookup(var.target_group_settings[count.index], "name", null)
  port        = lookup(var.target_group_settings[count.index], "target_port", null)
  protocol    = lookup(var.target_group_settings[count.index], "target_protocol", null)
  vpc_id      = lookup(var.target_group_settings[count.index], "vpc_id", null)
  #target_type = lookup(var.target_group_settings[count.index], "target_type", null)

  dynamic "health_check" {
    for_each = length(keys(lookup(var.target_group_settings[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_group_settings[count.index], "health_check", {})]
    
    content {
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "health_check_port", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  tags = var.default_tags

}
