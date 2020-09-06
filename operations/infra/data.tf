locals {
  additional_user_data_script = ""
  ecs_logging                 = "[\"json-file\",\"awslogs\",\"gelf\"]"
}

data "aws_vpc" "vpc" {
  #cluster = aws_ecs_cluster.cluster.id
  tags = { Name = "demovpc" }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  tags   = { Tier = "Public" }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id
  tags   = { Tier = "Private" }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.vpc.id
}

# AMI for ECS
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars = {
    ecs_logging                 = local.ecs_logging
    cluster_name                = aws_ecs_cluster.cluster.name
    additional_user_data_script = local.additional_user_data_script
  }
}

#data "template_file" "cluster_user_data" {
#template = file("provisioning/cluster.sh.tpl")

#vars = {
#ecs_cluster_name = aws_ecs_cluster.cluster.name
#}
#}

# AMI for Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

