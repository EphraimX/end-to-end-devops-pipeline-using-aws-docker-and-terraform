# Full Stack Dockerized Application Deployment on AWS with Terraform

This repository contains the code and configuration used to deploy a containerized application on AWS using Terraform.

The application includes a backend, frontend, and monitoring stack. The deployment provisions infrastructure on AWS using Terraform, sets up a bastion host for secure access, and makes the application accessible through an Application Load Balancer (ALB). The stack is deployed across public and private subnets within a VPC.

## Features

* Deployment of a full-stack Dockerized application.
* Infrastructure as Code with Terraform.
* Bastion host for SSH access to private instances.
* Private subnets for core services.
* Application accessible through an AWS ALB.
* Prometheus for metrics scraping.
* Grafana for monitoring dashboards.

## Infrastructure

<img width="2220" height="1140" alt="AWS Architectural Diagrams - API Gateway, Kubernetes, Docker, Docker Compose, Premethues, Grafana (1)" src="https://github.com/user-attachments/assets/ae15d3bb-80cf-4eec-bf21-91b005290067" />


The architecture includes a VPC with public and private subnets, an internet gateway, NAT gateway, route tables, and security groups. ECS is used to run Docker containers. A bastion host is used to SSH into private instances.

## Deployment Steps

1. Clone this repository.
2. Update the Terraform variables with your own values.
3. Add the following GitHub Secrets: DB_USER, DB_PASSWORD, DB_PORT (5432 for the Postgresql Database), AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY.
4. Push to start the CI/CD process.
5. Wait for the infrastructure to be provisioned.

## Accessing the Application

After deployment, the application is available at the ALB URL. The backend and frontend containers run in EC2 within a private subnet. The ALB handles traffic routing.

## Accessing Grafana

* Use the bastion host's public IP and SSH into it.
* From there, SSH into the private Prometheus instance.
* Open a browser and visit `http://<bastion_public_ip>:3000`.
* Log into Grafana (default credentials: `admin` / `admin`).
* Set the Prometheus data source to `http://<prometheus_private_ip>:9090`.

## Connecting via SSH

```bash
eval "$(ssh-agent -s)"
ssh-add ~/path/to/key-pair
ssh -A ubuntu@<bastion_ip>
ssh ubuntu@<private_ip>
```

Once connected, run `docker ps` to confirm containers are running.

## License

MIT License.
