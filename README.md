# Modern End-to-End DevOps Pipeline

## Project Overview

This project implements a modern end-to-end DevOps pipeline that automates infrastructure provisioning and application deployment.

The project uses **GitHub, Jenkins, Terraform, AWS, Ansible, Docker, Docker Compose, Maven, and Linux** to deploy two applications on the same AWS EC2 server:

1. A personal Portfolio Web Application
2. A Java Yearbook Web Application

The pipeline automates the deployment process from source code checkout and application build to infrastructure provisioning and application deployment.

---

## Project Objective

The objective of this project is to demonstrate how DevOps tools can work together to:

* Store source code in GitHub
* Build the Java application using Maven
* Provision AWS infrastructure using Terraform
* Configure the EC2 server using Ansible
* Containerize applications using Docker
* Run multiple applications using Docker Compose
* Automate deployment using Jenkins CI/CD

---

## Technology Stack

| Technology     | Purpose                                         |
| -------------- | ----------------------------------------------- |
| GitHub         | Source code management                          |
| Jenkins        | CI/CD automation                                |
| AWS            | Cloud infrastructure                            |
| Terraform      | Infrastructure as Code                          |
| HCP Terraform  | Remote Terraform execution and state management |
| Ansible        | Server configuration and deployment             |
| Docker         | Application containerization                    |
| Docker Compose | Running multiple containers                     |
| Maven          | Java application build                          |
| Nginx          | Portfolio web server                            |
| Java           | Java Yearbook application                       |
| Linux/Ubuntu   | Server operating system                         |

---

## Project Architecture

```text
                         GitHub
                            |
                            | Push Code
                            v
                         Jenkins
                            |
              +-------------+-------------+
              |                           |
              v                           v
        Maven Build                  Terraform
              |                           |
              |                           v
              |                    AWS Infrastructure
              |                           |
              |                          EC2
              |                           |
              +-----------------------> Ansible
                                           |
                                           v
                                      Docker Engine
                                           |
                                      Docker Compose
                                           |
                              +------------+------------+
                              |                         |
                              v                         v
                       Portfolio App              Java Yearbook
                          Port 80                  Port 8081
```

---

# AWS Infrastructure

Terraform provisions the following AWS resources:

* Custom VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group
* EC2 Instance

The EC2 server is deployed in the AWS `eu-west-2` region.

## Security Group

The EC2 security group allows the following inbound traffic:

| Port | Purpose                   |
| ---- | ------------------------- |
| 22   | SSH access                |
| 80   | Portfolio application     |
| 8081 | Java Yearbook application |

---

# Project Structure

```text
devops-capstone/
│
├── Jenkinsfile
├── docker-compose.yml
├── .gitignore
├── README.md
│
├── portfolio/
│   ├── Dockerfile
│   ├── index.html
│   └── style.css
│
├── java-app/
│   ├── Dockerfile
│   ├── pom.xml
│   └── src/
│       └── main/
│           └── java/
│               └── Application.java
│
├── terraform/
│   ├── main.tf
│   ├── vpc.tf
│   ├── subnet.tf
│   ├── internet_gateway.tf
│   ├── route_table.tf
│   ├── security_group.tf
│   └── ec2.tf
│
└── ansible/
    └── playbook.yml
```

The Ansible inventory file is generated dynamically by Jenkins during deployment.

Maven's generated `target/` directory is excluded from Git using `.gitignore`.

---

# Portfolio Application

The portfolio application is a simple personal website built using:

* HTML
* CSS
* Nginx

The application is containerized using Docker.

The portfolio Dockerfile uses the Nginx Alpine image and exposes port `80`.

The application is deployed through Docker Compose.

The portfolio is available at:

```text
http://<EC2-PUBLIC-IP>/
```

---

# Java Yearbook Application

The Java application is the **Java Yearbook application** from the original project repository:

```text
https://github.com/ProfAkymbo/java-yearbook-project
```

The application is implemented as a standalone Java HTTP server using Java's built-in HTTP server functionality.

The main application class is:

```text
java-app/src/main/java/Application.java
```

The application listens on port:

```text
8081
```

The application is built using Maven.

Jenkins builds the application using:

```bash
mvn -f java-app/pom.xml clean package -DskipTests
```

Maven produces the Java JAR file:

```text
java-app/target/java-yearbook-1.0.jar
```

The Docker image runs the JAR using Java.

The Java Docker container exposes port `8081`.

The Java Yearbook application is available at:

```text
http://<EC2-PUBLIC-IP>:8081/
```

---

# Docker

Both applications are containerized using Docker.

## Portfolio Container

The portfolio runs using Nginx:

```text
Container Port: 80
Host Port: 80
```

## Java Container

The Java Yearbook application runs using Java:

```text
Container Port: 8081
Host Port: 8081
```

---

# Docker Compose

Docker Compose is used to run both applications on the same EC2 server.

The Compose configuration is:

```yaml
services:
  portfolio:
    build: ./portfolio
    ports:
      - "80:80"

  java-app:
    build: ./java-app
    ports:
      - "8081:8081"
```

This allows both applications to run simultaneously on the same server using different ports.

---

# Ansible

Ansible is used to configure the EC2 server and deploy the applications.

The Ansible playbook performs the following tasks:

1. Updates the package repository
2. Installs Docker
3. Installs Docker Compose
4. Starts and enables the Docker service
5. Creates the application directory
6. Copies the Docker Compose configuration
7. Copies the portfolio application
8. Copies the Java application
9. Builds and starts the applications using Docker Compose

The deployment is executed using:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

The inventory file is generated automatically by Jenkins using the EC2 public IP address.

---

# Jenkins CI/CD Pipeline

Jenkins is the CI/CD tool used for this project.

The pipeline is defined in:

```text
Jenkinsfile
```

The Jenkins pipeline performs the following stages.

## 1. Checkout Code

Jenkins retrieves the latest source code from GitHub.

## 2. Build Java Application

Maven builds the Java Yearbook application:

```bash
mvn -f java-app/pom.xml clean package -DskipTests
```

The application is packaged as a JAR file.

## 3. Terraform Init

Terraform initializes the infrastructure configuration and connects to HCP Terraform.

## 4. Terraform Apply

Terraform provisions or verifies the AWS infrastructure.

## 5. Get EC2 Public IP

Jenkins retrieves the EC2 public IP address from Terraform:

```bash
terraform -chdir=terraform output -raw ec2_public_ip
```

## 6. Create Ansible Inventory

Jenkins dynamically creates the Ansible inventory using the EC2 public IP address.

## 7. Deploy with Ansible

Ansible connects to the EC2 server and deploys both applications using Docker Compose.

---

# CI/CD Flow

The complete deployment process is:

```text
Developer
    |
    | git push
    v
GitHub
    |
    v
Jenkins
    |
    +----> Maven
    |         |
    |         v
    |    Java JAR
    |
    +----> Terraform
    |          |
    |          v
    |         AWS
    |          |
    |         EC2
    |
    +----> Ansible
               |
               v
          Docker Engine
               |
          Docker Compose
             /      \
            /        \
           v          v
      Portfolio     Java Yearbook
        :80           :8081
```

---

# Application URLs

After a successful deployment, the applications are available at:

## Portfolio

```text
http://<EC2-PUBLIC-IP>/
```

## Java Yearbook

```text
http://<EC2-PUBLIC-IP>:8081/
```

---

# Local Testing

The applications can also be tested locally using Docker Compose.

Start both applications with:

```bash
docker compose up -d --build
```

Check the running containers:

```bash
docker compose ps
```

The portfolio can be accessed at:

```text
http://localhost
```

The Java Yearbook application can be accessed at:

```text
http://localhost:8081
```

---

# Deployment Verification

A successful Jenkins deployment should complete with:

```text
Deployment completed successfully!
```

Ansible should complete without unreachable or failed hosts.

Expected Ansible summary:

```text
ok=9
unreachable=0
failed=0
```

The Maven build should report:

```text
BUILD SUCCESS
```

Terraform should report that the infrastructure matches the configuration when no infrastructure changes are required.

---

# Security

Sensitive information is not stored directly in the GitHub repository.

The following information should remain private:

* AWS access keys
* HCP Terraform API tokens
* SSH private keys
* Passwords
* Other authentication credentials

Jenkins credentials are used to securely provide the required secrets during the pipeline.

The `.gitignore` file prevents sensitive files and generated files from being committed.

---

# DevOps Skills Demonstrated

This project demonstrates practical experience with:

* Git and GitHub
* Linux
* AWS
* VPC networking
* EC2
* Security Groups
* Infrastructure as Code
* Terraform
* HCP Terraform
* Ansible
* Docker
* Docker Compose
* Maven
* Jenkins
* CI/CD
* SSH
* Containerized application deployment
* Cloud infrastructure automation

---

# Project Outcome

The completed project provides an automated DevOps workflow capable of taking application code from GitHub, building the Java Yearbook application, provisioning AWS infrastructure with Terraform, configuring the EC2 server with Ansible, and deploying two containerized applications using Docker Compose.

The final environment runs both the Portfolio Web Application and Java Yearbook application on the same AWS EC2 server.

The Portfolio application is served on port `80`, while the Java Yearbook application is served on port `8081`.

---

# Conclusion

This project demonstrates how multiple DevOps technologies can be integrated into a single automated deployment pipeline.

By combining GitHub, Jenkins, Terraform, AWS, Ansible, Docker, Docker Compose, and Maven, the deployment process becomes repeatable and automated instead of relying on manual server configuration and application deployment.
