locals {
  alb_name       = "demoalb"
  web_lb_tg_name = "webtg"
  api_lb_tg_name = "apitg"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name               = local.alb_name
  load_balancer_type = "application"

  vpc_id          = local.vpc_id
  subnets         = local.public_subnets
  security_groups = [local.security_group_id]

  http_tcp_listeners = [
    {
      target_group_index = 0
      port               = 80
      protocol           = "HTTP"
      action_type        = "forward"
    },
    {
      target_group_index = 0
      port               = 80
      protocol           = "HTTP"
      action_type        = "forward"
    },
  ]

  target_groups = [

    # Target Group for web app
    {
      name_prefix          = local.web_lb_tg_name
      backend_port         = 80
      backend_protocol     = "HTTP"
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 5
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 4
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = local.web_lb_tg_name
      }
    },

    # Target Group for api app
    {
      name_prefix          = local.api_lb_tg_name
      backend_port         = 80
      backend_protocol     = "HTTP"
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 5
        path                = "/api/status"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 4
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = local.api_lb_tg_name
      }
    },
  ]
}

resource "aws_lb_listener_rule" "web-lb-rule" {
  priority     = 100
  listener_arn = module.alb.http_tcp_listener_arns[0]

  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[0]
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_listener_rule" "api-lb-rule" {
  priority     = 200
  listener_arn = module.alb.http_tcp_listener_arns[0]

  action {
    type             = "forward"
    target_group_arn = module.alb.target_group_arns[1]
  }

  condition {
    path_pattern {
      values = ["/api/status"]
    }
  }
}
