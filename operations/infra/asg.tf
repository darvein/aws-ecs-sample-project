locals {
  asg_name           = "${var.project_name}-asg"
  ec2_resources_name = "${var.project_name}-${var.environment}"

  vpc_id            = data.aws_vpc.vpc.id
  public_subnets    = data.aws_subnet_ids.public.ids
  security_group_id = module.sg.this_security_group_id
}

module "ec2_autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name    = local.asg_name
  lc_name = local.ec2_resources_name

  key_name             = aws_key_pair.ssh.key_name
  image_id             = data.aws_ami.ami.id
  instance_type        = var.instance_type
  security_groups      = [local.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.cluster.name
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = local.asg_name
  vpc_zone_identifier       = local.public_subnets
  health_check_type         = "EC2"
  min_size                  = var.asg_minimum_size
  max_size                  = var.asg_maximum_size
  desired_capacity          = var.asg_desired_size
  wait_for_capacity_timeout = 0

  enable_monitoring = true
}

resource "aws_cloudwatch_metric_alarm" "ecs-alert_High-CPUReservation" {
  alarm_name          = "${var.project_name}-ECS-High_CPUResv"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  period              = "240"
  evaluation_periods  = "1" # TODO Set this to 2
  datapoints_to_alarm = 1

  threshold         = var.asg_high_capacity_percent
  statistic         = "Average"
  alarm_description = "Running out of CPU!"

  metric_name = "CPUReservation"
  namespace   = "AWS/ECS"
  dimensions = {
    ClusterName = "${var.project_name}cluster"
  }

  actions_enabled           = true
  insufficient_data_actions = []
  ok_actions                = []
  alarm_actions = [
    "${aws_autoscaling_policy.ecs-asg_increase.arn}"
  ]
}

resource "aws_cloudwatch_metric_alarm" "ecs-alert_Low-CPUReservation" {
  alarm_name          = "${var.project_name}-ECS-Low_CPUResv"
  comparison_operator = "LessThanThreshold"

  period              = "180"
  evaluation_periods  = "1"
  datapoints_to_alarm = 1

  threshold         = var.asg_low_capacity_percent
  statistic         = "Average"
  alarm_description = "Resources not being used!"

  metric_name = "CPUReservation"
  namespace   = "AWS/ECS"
  dimensions = {
    ClusterName = "${var.project_name}cluster"
  }

  ok_actions                = []
  actions_enabled           = true
  insufficient_data_actions = []

  alarm_actions = [
    "${aws_autoscaling_policy.ecs-asg_decrease.arn}",
  ]
}

resource "aws_autoscaling_policy" "ecs-asg_decrease" {
  name = "${var.project_name}-ECS-ASG_Decrease"

  cooldown               = 30
  scaling_adjustment     = -1
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = module.ec2_autoscaling.this_autoscaling_group_name
}

resource "aws_autoscaling_policy" "ecs-asg_increase" {
  name = "${var.project_name}-ECS-ASG_Increase"

  cooldown               = 30
  scaling_adjustment     = 2
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = module.ec2_autoscaling.this_autoscaling_group_name
}

