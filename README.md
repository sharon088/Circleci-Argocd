# CircleCI pipeline to deploy with TF, EKS and ArgoCD

This repository contains the configuration and code to deploy a **Weather WebApp** to an **EKS (Elastic Kubernetes Service)** cluster using **ArgoCD** for GitOps-based continuous deployment. Additionally, we implement **Chaos Engineering** using **Netflix Chaos Monkey** and **Chaos Mesh** to ensure the resilience of the cluster by intentionally injecting failures.

## Table of Contents
- [Features](#features)
- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [Clone the Repository](#1-clone-the-repository)
  - [Configure AWS Credentials](#2-configure-aws-credentials)
  - [Terraform Configuration](#3-terraform-configuration)
  - [ArgoCD Setup](#4-argocd-setup)
  - [Chaos Engineering Setup with Chaos Mesh](#5-chaos-engineering-setup-with-chaos-mesh)
  - [CircleCI Configuration](#6-circleci-configuration)
  - [Validate the System](#7-validate-the-system)
- [Conclusion](#conclusion)

## Features
- **EKS Cluster Deployment**: Terraform-managed EKS cluster.
- **ArgoCD Integration**: Continuous deployment of apps to Kubernetes using ArgoCD.
- **Chaos Engineering**: Implemented using Netflix's Chaos Monkey and Chaos Mesh to simulate pod failures and ensure resilience.
- **CI/CD Pipeline**: Automated deployment and resilience testing using CircleCI.

## Architecture Overview
1. **Terraform**: Manages the infrastructure, including the creation of the EKS cluster.
2. **ArgoCD**: GitOps continuous deployment tool that syncs application deployments from Git to Kubernetes.
3. **Chaos Engineering**: Utilizes **Chaos Mesh** to simulate failures in the EKS cluster, ensuring that the app is resilient to failures.
4. **CircleCI**: Automates the build, test, and deployment processes, including resilience tests post-deployment.

## Prerequisites

- **AWS Account**: You need an AWS account with appropriate IAM permissions to create and manage EKS clusters.
- **Kubernetes**: Kubernetes 1.21+ configured to interact with EKS.
- **Terraform**: Version 1.1 or later for infrastructure provisioning.
- **ArgoCD**: Set up ArgoCD on the EKS cluster for managing Kubernetes applications.
- **CircleCI Account**: Used to automate the CI/CD pipeline.
- **Docker**: For building and pushing the Docker container image.

## Setup Instructions

### 1. **Clone the Repository**

```bash
git clone https://github.com/your-org/weather-webapp.git
cd weather-webapp
```

### 2. **Configure AWS Credentials**

Make sure your AWS credentials are set up either via the AWS CLI, environment variables, or IAM roles if running within AWS infrastructure.

```bash
aws configure
```

### 3. **Terraform Configuration**

Terraform is used to provision your EKS cluster.

#### Initialize Terraform

```bash
terraform init
```

#### Apply Terraform Configuration

This will create the necessary AWS infrastructure, including the EKS cluster.

```bash
terraform apply -auto-approve
```

### 4. **ArgoCD Setup**

ArgoCD will be used for continuous delivery of the application to the EKS cluster. We assume you already have ArgoCD set up on your cluster. If not, refer to the [ArgoCD documentation](https://argoproj.github.io/argo-cd/) for installation instructions.

#### Add ArgoCD App to Kubernetes

ArgoCD will manage the deployment of the application and chaos experiments. You need to set up an ArgoCD application that points to the `manifests` directory in your repository.

Commit and push this file to your repository. ArgoCD will automatically deploy and manage the application based on the Git repository.

### 5. **Chaos Engineering Setup with Chaos Mesh**

To simulate pod failures and validate that your app can recover, we use **Chaos Mesh**.

#### Deploy Chaos Mesh

Apply the Chaos Mesh deployment YAML:

```bash
kubectl apply -f chaos-monkey-deployment.yaml
```

This will deploy the Chaos Monkey pod in the `default` namespace. Ensure that it is running properly by checking the pods:

```bash
kubectl get pods -n default
```

#### Configure Chaos Experiment

To simulate random pod termination, create a Chaos Experiment YAML file (e.g., `chaos-monkey-experiment.yaml`) to run the chaos monkey experiment on your EKS cluster:

#### Apply the Chaos Experiment

```bash
kubectl apply -f chaos-monkey-experiment.yaml
```

This will randomly terminate a pod every minute.

### 6. **CircleCI Configuration**

Your CircleCI pipeline will handle the build, test, and deployment process. It will also run a resilience test post-deployment to verify the system's ability to handle failures caused by Chaos Monkey.

### 7. **Validate the System**

After the pipeline finishes, validate that the chaos experiments were executed and that the app was able to recover from the injected failure. You can do this by checking the logs of the pods and the status of the deployment.

## Conclusion

This setup allows you to:

- Automate the deployment of your **Weather WebApp** to an EKS cluster using **ArgoCD**.
- Ensure the system can tolerate failures by introducing **Chaos Engineering**.
- Continuously test the application's resilience via **CircleCI**.

This approach ensures high availability and reliability by simulating real-world failures and verifying that the system can self-heal.
