# Infrastructure and Continuous delivery for node-3tier-app2

## Proposed infrastructure

### Database

Managed AWS RDS Postgresql

### Frontend

AWS ECS `web` service

### Backend

AWS ECS `api` service


## Tooling

- IaaC: Terraform
- Applications web and api: Docker 


## Deploy

Export AWS Creds: `export AWS_PROFILE=<profile name>`

## Resources deployed:

- Ecs cluster: ecr, ecs, iams, alb, target groups, asg
- Rds postgresql
- Ec2 graylog
- Ec2 prometheus
