# Target Group for Application UI on port 5001
resource "aws_lb_target_group" "app_ui_target_group" {
  name     = "app-ui-target-group"
  port     = 5001
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group for Stock Metrics on port 8000
resource "aws_lb_target_group" "stock_metrics_target_group" {
  name     = "stock-metrics-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group for Mongo Express on port 8081
resource "aws_lb_target_group" "mongo_express_target_group" {
  name     = "mongo-express-target-group"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group for Promtail on port 9080
resource "aws_lb_target_group" "promtail_target_group" {
  name     = "promtail-target-group"
  port     = 9080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group for Loki on port 3100
resource "aws_lb_target_group" "loki_target_group" {
  name     = "loki-target-group"
  port     = 3100
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group for Prometheus on port 9090
resource "aws_lb_target_group" "prometheus_target_group" {
  name     = "prometheus-target-group"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Target Group for Grafana on port 3000
resource "aws_lb_target_group" "grafana_target_group" {
  name     = "grafana-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
