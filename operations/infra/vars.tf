variable "region" { default = "us-east-1" }
variable "ssh_public_key_path" { default = "~/.ssh/id_rsa.pub" }

variable "environment" { default = "demoenv" }
variable "instance_type" { default = "t2.small" }
variable "project_name" { default = "demoproject" }

variable "asg_minimum_size" { default = 2 }
variable "asg_desired_size" { default = 2 }
variable "asg_maximum_size" { default = 6 }
variable "asg_low_capacity_percent" { default = "50" }
variable "asg_high_capacity_percent" { default = "85" }

variable "web_name" { default = "web" }
variable "web_service_min_size" { default = 1 }
variable "web_service_desired_size" { default = 4 }
variable "web_service_max_size" { default = 20 }
variable "web_container_port" { default = 3000 }

variable "api_name" { default = "api" }
variable "api_service_min_size" { default = 1 }
variable "api_service_desired_size" { default = 4 }
variable "api_service_max_size" { default = 20 }
variable "api_container_port" { default = 3000 }

variable "prometheus_instance_type" { default = "t2.large" }
variable "graylog_instance_type" { default = "t2.large" }
