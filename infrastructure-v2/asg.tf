#### Application Autoscaling Group
resource "aws_autoscaling_group" "ec2_app_asg" {
  vpc_zone_identifier         = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.ec2_app_template.id
    version = "$Latest"
  }

  min_size                    = 1
  max_size                    = 2
  desired_capacity            = 2
  
  target_group_arns           = [aws_lb_target_group.app_ui_target_group.arn]

  tag {
    key                 = "Name"
    value               = "${local.tags.Environment}-ec2-instance"
    propagate_at_launch = true
  }
}

#### Monitoring Autoscaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  vpc_zone_identifier         = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.ec2_monitoring_template.id
    version = "$Latest"
  }

  min_size                    = 1
  max_size                    = 1
  desired_capacity            = 1
  
  target_group_arns           = [aws_lb_target_group.stock_metrics_target_group.arn]

  tag {
    key                 = "Name"
    value               = "${local.tags.Environment}-ec2-instance"
    propagate_at_launch = true
  }
}

#### DB Autoscaling Group
resource "aws_autoscaling_group" "ec2_db_asg" {
  vpc_zone_identifier         = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.ec2_db_template.id
    version = "$Latest"
  }

  min_size                    = 1
  max_size                    = 1
  desired_capacity            = 1
  
  target_group_arns           = [aws_lb_target_group.mongo_express_target_group.arn]

  tag {
    key                 = "Name"
    value               = "${local.tags.Environment}-ec2-instance"
    propagate_at_launch = true
  }
}
