locals {
  availability_zones = "us-east-1b,us-east-1b" # TODO from data
  gelf_port          = 12201
}


# ECS 

resource "aws_ecs_cluster" "cluster" { name = "${var.project_name}cluster" }


# ECR

resource "aws_ecr_repository" "api" { name = var.api_name }
resource "aws_ecr_repository" "web" { name = var.web_name }


# ECS Service for web app

resource "aws_ecs_service" "web_svc" {
  name = "${var.project_name}-${var.web_name}-svc"

  cluster         = aws_ecs_cluster.cluster.id
  desired_count   = var.web_service_desired_size
  iam_role        = aws_iam_role.cluster_service_role.arn
  task_definition = aws_ecs_task_definition.web_task.arn

  deployment_maximum_percent         = "100"
  deployment_minimum_healthy_percent = "50"

  load_balancer {
    container_port   = var.web_container_port
    container_name   = var.web_name
    target_group_arn = module.alb.target_group_arns[0]
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  #lifecycle { ignore_changes = [desired_count] }
}

data "template_file" "web_task_template" {
  template = "${file("${path.module}/templates/web-task.json.tpl")}"

  vars = {
    image          = "${aws_ecr_repository.web.repository_url}:latest"
    alb_url        = "http://${module.alb.this_lb_dns_name}"
    gelf_address   = "udp://${aws_instance.graylog.private_ip}:${local.gelf_port}"
    container_port = var.web_container_port
  }
}

resource "aws_ecs_task_definition" "web_task" {
  family                = var.web_name
  container_definitions = data.template_file.web_task_template.rendered
}

resource "aws_appautoscaling_target" "web_ecs_target" {
  max_capacity       = var.web_service_max_size
  min_capacity       = var.web_service_min_size
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.web_svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "web_ecs_policy" {
  name               = "scale"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.web_ecs_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.web_ecs_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.web_ecs_target.service_namespace}"

  step_scaling_policy_configuration {
    adjustment_type         = "PercentChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Average"

    step_adjustment {
      #metric_interval_lower_bound = -10
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
    step_adjustment {
      metric_interval_lower_bound = 0
      #metric_interval_upper_bound = 10
      scaling_adjustment = 1
    }
  }
}

# ECS Service for api app

resource "aws_ecs_service" "api_svc" {
  name = "${var.project_name}-${var.api_name}-svc"

  cluster         = aws_ecs_cluster.cluster.id
  desired_count   = var.api_service_desired_size
  iam_role        = aws_iam_role.cluster_service_role.arn
  task_definition = aws_ecs_task_definition.api_task.arn

  deployment_maximum_percent         = "100"
  deployment_minimum_healthy_percent = "50"

  load_balancer {
    container_port   = var.api_container_port
    container_name   = var.api_name
    target_group_arn = module.alb.target_group_arns[1]
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  #lifecycle { ignore_changes = [desired_count] }
}

data "template_file" "api_task_template" {
  template = "${file("${path.module}/templates/api-task.json.tpl")}"

  vars = {
    db             = "postgres://${local.db_user}:${local.db_password}@${module.db.this_db_instance_endpoint}/${var.project_name}"
    container_port = var.api_container_port
    gelf_address   = "udp://${aws_instance.graylog.private_ip}:${local.gelf_port}"
    image          = "${aws_ecr_repository.api.repository_url}:latest"
  }
}

resource "aws_ecs_task_definition" "api_task" {
  family                = var.api_name
  container_definitions = data.template_file.api_task_template.rendered
}

resource "aws_appautoscaling_target" "api_ecs_target" {
  max_capacity       = var.api_service_max_size
  min_capacity       = var.api_service_min_size
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.api_svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "api_ecs_policy" {
  name               = "scale"
  policy_type        = "StepScaling"
  resource_id        = "${aws_appautoscaling_target.api_ecs_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.api_ecs_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.api_ecs_target.service_namespace}"

  step_scaling_policy_configuration {
    adjustment_type         = "PercentChangeInCapacity"
    cooldown                = 30
    metric_aggregation_type = "Average"

    step_adjustment {
      #metric_interval_lower_bound = -10
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
    step_adjustment {
      metric_interval_lower_bound = 0
      #metric_interval_upper_bound = 10
      scaling_adjustment = 1
    }
  }
}
