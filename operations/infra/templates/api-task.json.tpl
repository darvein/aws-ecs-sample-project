[
  {
    "name": "api",
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
        "name": "DB",
        "value": "${db}"
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
