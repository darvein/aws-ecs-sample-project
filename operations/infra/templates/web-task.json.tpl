[
  {
    "name": "web",
    "image": "${image}",
    "cpu": 300,
    "memory": 100,
    "essential": true,
    "portMappings": [
      {
        "hostPort": 0,
        "containerPort": ${container_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        "name": "API_HOST",
        "value": "${alb_url}"
      }
    ],
    "logConfiguration": {
      "logDriver": "gelf",
      "options": {
        "gelf-address": "${gelf_address}"
      }
    }
  }
]
