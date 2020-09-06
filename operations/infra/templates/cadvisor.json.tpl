[
{
  "name": "cadvisor",
    "image": "google/cadvisor",
    "cpu": 20,
    "memory": 50,
    "portMappings": [
    {
      "containerPort": 8080,
      "hostPort": 8080
    }
    ],
    "essential": true,
    "mountPoints": [
    {
      "sourceVolume": "root",
      "containerPath": "/rootfs",
      "readOnly": true
    },
    {
      "sourceVolume": "var_run",
      "containerPath": "/var/run",
      "readOnly": false
    },
    {
      "sourceVolume": "sys",
      "containerPath": "/sys",
      "readOnly": true
    },
    {
      "sourceVolume": "cgroup",
      "containerPath": "/sys/fs/cgroup",
      "readOnly": true
    },
    {
      "sourceVolume": "dev_disk",
      "containerPath": "/dev/disk",
      "readOnly": true
    },
    {
      "sourceVolume": "var_lib_docker",
      "containerPath": "/var/lib/docker",
      "readOnly": true
    }
    ]
}
]
