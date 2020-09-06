locals {
  iam_service_role_name = "${var.project_name}-role"
}

# Service Role

resource "aws_iam_role" "cluster_service_role" {
  name               = local.iam_service_role_name
  assume_role_policy = file("iam/cluster-service-role.json")
}

resource "aws_iam_policy" "cluster_service_policy" {
  policy = file("iam/cluster-service-policy.json")
}

resource "aws_iam_policy_attachment" "cluster_service_policy_attachment" {
  name       = "cluster-instance-policy-attachment-${var.project_name}"
  policy_arn = aws_iam_policy.cluster_service_policy.arn
  roles      = [aws_iam_role.cluster_service_role.id]
}

# Cluster Role (ec2)

resource "aws_iam_role" "cluster_instance_role" {
  name               = "cluster-instance-role-${var.project_name}"
  assume_role_policy = file("iam/cluster-instance-role.json")
}

resource "aws_iam_policy" "cluster_instance_policy" {
  name   = "cluster-instance-policy-${var.project_name}"
  policy = file("iam/cluster-instance-policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.cluster_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "cluster" {
  name = "cluster-instance-profile-${var.project_name}"
  role = aws_iam_role.cluster_instance_role.name
}
