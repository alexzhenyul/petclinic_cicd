# Overview

This project demonstrates the implementation of a multi-stage CI/CD pipeline for the Spring PetClinic web application using Jenkins,  Terraform & AWS infrastrcuture. The pipeline automates the provisioning of infrastructure, deployment, and testing of the application, ensuring a streamlined and efficient development workflow.

Reference: https://github.com/spring-projects/spring-petclinic

# Table of Contents - To be completed
1. Project Structure
2. Prerequisites
3. Set up
   a. Infrastructure Provisioning
   b. jenkins ec2 & S3 bucket(tfstate file)
4. CI/CD Pipeline
5. License

# Project Structure
Pending

# Prerequisites
1. JDK 17+
2. Maven
3. Terraform
4. Docker
5. Docker-Compose
6. AWS CLI
7. Jenkins
   

# Setup
## Infrastructure Diagram
Pending

## Infrastructure Provisioning
1. Initialize Terraform
```
cd terraform
terraform init
```

2. Apply Terraform Configuration
```
terraform apply
```

# CI/CD Pipeline
## CI/CD Pipeline Diagram
Pending

## Stages
1. Code
   a. Clean existing petclinic directory
   b. Clone GitHub repository
   c. Compile via Maven
2. Test
   a. Unit test
   b. Check style
   c. Code Coverage
3. Container
   a. Build jar file
   b. Tag docker images
   c. Push docker images to dockerhub/ECR
4. Deployment
   a. Provioning EC2/EKS cluser
   b. Deploy application on EC2/EKS

# Monitoring & Maintenances
Pending

# Licenses
The Spring PetClinic sample application is released under version 2.0 of the Apache License.