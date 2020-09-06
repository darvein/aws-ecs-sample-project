#cloud-config

bootcmd:
- echo 'ECS_CLUSTER=${ecs_cluster_name}' >> /etc/ecs/ecs.config
- echo 'ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","syslog","awslogs","gelf"]' >> /etc/ecs/ecs.config
