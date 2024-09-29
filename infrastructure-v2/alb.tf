resource "aws_lb" "alb" {
  name               = "trading-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = merge(local.tags, { Name = "${local.tags.Environment}-alb" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_ui_target_group.arn
  }
}


# Rule for Application UI on /ui
resource "aws_lb_listener_rule" "app_ui_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_ui_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/ui/*"]
    }
  }
}

# Rule for Stock Metrics on /metrics
resource "aws_lb_listener_rule" "stock_metrics_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 110

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stock_metrics_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/metrics/*"]
    }
  }
}

# Rule for Mongo Express on /mongo-express
resource "aws_lb_listener_rule" "mongo_express_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 120

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mongo_express_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/mongo-express/*"]
    }
  }
}

# Rule for Promtail on /promtail
resource "aws_lb_listener_rule" "promtail_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 130

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.promtail_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/promtail/*"]
    }
  }
}

# Rule for Loki on /loki
resource "aws_lb_listener_rule" "loki_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 140

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loki_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/loki/*"]
    }
  }
}

# Rule for Prometheus on /prometheus
resource "aws_lb_listener_rule" "prometheus_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 150

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/prometheus/*"]
    }
  }
}

# Rule for Grafana on /grafana
resource "aws_lb_listener_rule" "grafana_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 160

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/grafana/*"]
    }
  }
}
