# Full Node Tier3 Application

  * [Requisites](#requisites)
* [Application development](#application-development)
  * [Configure the application](#configure-the-application)
  * [Build and run the application](#build-and-run-the-application)
  * [Package and push](#package-and-push)
  * [Continuous Integration and Continuous Deployment](#continuous-integration-and-continuous-deployment)
* [Infrastructure and operations](#infrastructure-and-operations)
  * [Pre-requisites](#pre-requisites)
  * [Deploy infrastructure](#deploy-infrastructure)
    * [Configure the infrastructure](#configure-the-infrastructure)
    * [DEploy the infrastructure](#deploy-the-infrastructure)
    * [Install Graylog and Prometheus services](#install-graylog-and-prometheus-services)
    * [Destroy](#destroy)

This project contains the application itself (frontend and backend) as well as the CI/CD, infrastructure and orchestrated operations tooling.

### Requisites

In order to lunch the project you will require:

- An AWS Account
- A Gitlab Account (for the git service and CI/CD)
- Terraform CLI tool installed
- Docker engine installed (just for development purposes if needed)

## Application development

First of all, move to the application directory: `cd node-3tier-app2`

### Configure the application

Duplicate the `.env.example` file and modify it with your custom values.

### Build and run the application

The node-3tier-app2 directory contains the `api/` and the `web/` applications which are the backend and frontend applications.

Build both applications:

```bash
make api-build
make web-build
```

Run both applications:

```bash
make api-run
make web-run
```

### Package and push

This will just tag the docker images and push it to the docker registry.

```bash
make api-tag
make web-tag

make api-release
make web-release
```

### Continuous Integration and Continuous Deployment

The project is using Gitlab's CI/CD pipeline feature which is defined in a `.gitlab-ci.yml` file. This takes care of the build and deployment of the application.

## Infrastructure and operations
You will need to move to `operations/` directory.

### Pre-requisites

You will need to have an existing VPC, if not no worries you can go to `operations/infra-base` directory and deploy your brandy new VPC.

```bash
terraform init
terraform plan
terraform apply
```

Once done, before you start deploying anything you have to provide your aws credentials via environment variables or just setting up the right AWS Profile.

`export AWS_PROFILE=<name of your profile>`

### Deploy infrastructure

This will deploy the underlying infrastructure needed for:

- Dockerized backend and frontend application with Load Balancer and CDN
- Graylog service for log agregation
- Prometheus for System overall metrics


#### Configure the infrastructure

Before deploying it you can tune a bit the infrastructure by editing the file `.env`, notice that you will need to create your own by copying the template `.env.example`.

#### DEploy the infrastructure

In order to deploy just run:

```bash
make tf-apply
make tf-outputs
```

And you will as a result the output of Terraform a set of public ip addresses, load balancer and CDN endpoint.

#### Install Graylog and Prometheus services

You just need to run:

```bash
make provision-graylog
make provision-prometheus
```

And you can start monitoring the logs and metrics of the whole system. Remember to check the ip addresses for accessing the services via: `make tf-outpus`

#### Destroy

If you want to clean up everything, then just run:

```bash
make tf-destroy
```
