resource "aws_lb" "alb" {
  name               = "trading-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = merge(local.tags, { Name = "${local.tags.Environment}-alb" })
}

# Listener for Application UI on port 5001
resource "aws_lb_listener" "app_ui_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 5001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_ui_target_group.arn
  }
}

# Listener for Stock Metrics on port 8000
resource "aws_lb_listener" "stock_metrics_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stock_metrics_target_group.arn
  }
}

# Listener for Mongo Express on port 8081
resource "aws_lb_listener" "mongo_express_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8081
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mongo_express_target_group.arn
  }
}

# Listener for Promtail on port 9080
resource "aws_lb_listener" "promtail_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 9080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.promtail_target_group.arn
  }
}

# Listener for Loki on port 3100
resource "aws_lb_listener" "loki_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 3100
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loki_target_group.arn
  }
}

# Listener for Prometheus on port 9090
resource "aws_lb_listener" "prometheus_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_target_group.arn
  }
}

# Listener for Grafana on port 3000
resource "aws_lb_listener" "grafana_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_target_group.arn
  }
}
