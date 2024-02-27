#########################################################################################
#                                                                                       #                                 
#                                 APPLICATION LOAD BALANCER                             #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb" "main" {
  count = var.create ? 1 : 0

  name               = lookup(var.load_balancing_settings[count.index], "name", null)
  internal           = lookup(var.load_balancing_settings[count.index], "internal", null)
  load_balancer_type = lookup(var.load_balancing_settings[count.index], "load_balancer_type", null)
  security_groups    = lookup(var.load_balancing_settings[count.index], "security_groups", null)
  subnets            = lookup(var.load_balancing_settings[count.index], "subnets", null)

  tags = var.default_tags
}


#########################################################################################
#                                                                                       #
#                             LOAD BALANCER LISTENER - HTTP PORT                        #
#                                                                                       #
#########################################################################################

resource "aws_lb_listener" "listerner_http" {
  count = var.create && var.load_balancer_type == "application" ? length(var.load_balancing_listener_http) : 0

  load_balancer_arn = aws_lb.main.0.arn
  port              = lookup(var.load_balancing_listener_http[count.index], "port", null)
  protocol          = lookup(var.load_balancing_listener_http[count.index], "protocol", null)

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
#                            LOAD BALANCER LISTENER - HTTPS PORT                        #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb_listener" "listerner_https" {
  count = var.create && var.load_balancer_type == "application" ? length(var.load_balancing_listener_https) : 0

  #load_balancer_arn = lookup(var.load_balancing_listener_http[count.index], "load_balancer_arn", null)
  load_balancer_arn = aws_lb.main.0.arn
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
#                              REDIRECT RULE [HTTP PORT 80 ]                            #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb_listener_rule" "lb_https" {
  count = var.create && var.cluster_type == "FARGATE" || var.cluster_type == "EC2" ? length(var.service_load_balancing_https) : 0

  listener_arn = aws_lb_listener.listerner_http.0.arn
  priority     = lookup(var.service_load_balancing_https[count.index], "priority_rule", null)

  dynamic "action" {
    for_each = length(keys(lookup(var.service_load_balancing_https[count.index], "redirect_rule", {}))) == 0 ? [] : [lookup(var.service_load_balancing_https[count.index], "redirect_rule", {})]
    content {
      type = lookup(action.value, "type", null)

      dynamic "redirect" {
        for_each = length(keys(lookup(action.value, "redirect", {}))) == 0 ? [] : [lookup(action.value, "redirect", {})]
        content {
          port        = lookup(redirect.value, "type", "443")
          protocol    = lookup(redirect.value, "protocol", "HTTPS")
          status_code = lookup(redirect.value, "status_code", "HTTP_301")
        }
      }
    }
  }

  dynamic "condition" {
    for_each = length(keys(lookup(var.service_load_balancing_https[count.index], "condition", {}))) == 0 ? [] : [lookup(var.service_load_balancing_https[count.index], "condition", {})]
    content {
      dynamic "path_pattern" {
        for_each = length(keys(lookup(condition.value, "path_pattern", {}))) == 0 ? [] : [lookup(condition.value, "path_pattern", {})]
        content {
          values = lookup(path_pattern.value, "values", null)
        }
      }
    }
  }
}

#########################################################################################
#                                                                                       #                                 
#                  LOAD BALANCER HTTPS LISTENER RULE (443) - HOST HEADER                #
#                                                                                       #                                 
#########################################################################################

resource "aws_lb_listener_rule" "listener_https" {
  count = var.create ? length(var.listener_rule) : 0

  listener_arn = aws_lb_listener.listerner_https.0.arn

  dynamic "action" {
    for_each = length(keys(lookup(var.listener_rule[count.index], "action", {}))) == 0 ? [] : [lookup(var.listener_rule[count.index], "action", {})]

    content {
      type = lookup(action.value, "type", null)
      #target_group_arn = lookup(action.value, "target_group_arn", null)
      target_group_arn = aws_lb_target_group.main.0.arn
    }
  }

  dynamic "condition" {
    for_each = length(keys(lookup(var.listener_rule[count.index], "condition", {}))) == 0 ? [] : [lookup(var.listener_rule[count.index], "condition", {})]

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

  name     = lookup(var.target_group_settings[count.index], "name", null)
  port     = lookup(var.target_group_settings[count.index], "target_port", null)
  protocol = lookup(var.target_group_settings[count.index], "target_protocol", null)
  vpc_id   = lookup(var.target_group_settings[count.index], "vpc_id", null)
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