# Modern End-to-End DevOps Pipeline

## Project Overview

This project implements a modern end-to-end DevOps pipeline that automates infrastructure provisioning and application deployment.

The project uses **GitHub, Jenkins, Terraform, AWS, Ansible, Docker, Docker Compose, Maven, and Linux** to deploy two different applications on the same AWS EC2 server:

1. A personal Portfolio Web Application
2. A Java Web Application

The pipeline automates the process from source code checkout to application deployment.

---

## Project Objective

The objective of this project is to demonstrate how DevOps tools can work together to:

* Store source code in GitHub
* Build the Java application using Maven
* Provision AWS infrastructure using Terraform
* Configure the EC2 server using Ansible
* Containerize applications using Docker
* Run multiple applications using Docker Compose
* Automate the deployment process using Jenkins

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
| Apache Tomcat  | Java application server                         |
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
              |                         EC2
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
                       Portfolio App              Java App
                          Port 80                  Port 8081
```

---

## AWS Infrastructure

Terraform provisions the following AWS resources:

* Custom VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group
* EC2 Instance

The EC2 server is deployed in the AWS `eu-west-2` region.

### Security Group

The EC2 security group allows:

| Port | Purpose               |
| ---- | --------------------- |
| 22   | SSH                   |
| 80   | Portfolio application |
| 8081 | Java application      |

---

## Project Structure

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
│   ├── build.gradle
│   └── src/
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

---

# Portfolio Application

The portfolio application is a simple personal website built using:

* HTML
* CSS
* Nginx

The application is containerized using Docker.

### Portfolio Dockerfile

The portfolio uses an Nginx Alpine image and exposes port 80.

The application is deployed through Docker Compose.

---

# Java Application

The Java application is a Maven-based web application packaged as a WAR file.

Jenkins builds the application using:

```bash
mvn -f java-app/pom.xml clean package -DskipTests
```

The resulting WAR file is used to build the Java Docker image.

The Java application runs using Apache Tomcat inside a Docker container.

---

# Docker Compose

Docker Compose is used to run both applications on the same EC2 server.

```yaml
services:
  portfolio:
    build: ./portfolio
    ports:
      - "80:80"

  java-app:
    build: ./java-app
    ports:
      - "8081:8080"
```

This allows both applications to run on the same server using different ports.

---

# Ansible

Ansible is used to configure the EC2 server and deploy the applications.

The Ansible playbook performs tasks including:

1. Updating the package repository
2. Installing Docker
3. Installing Docker Compose
4. Starting the Docker service
5. Creating the application directory
6. Copying the Docker Compose configuration
7. Copying the portfolio application
8. Copying the Java application
9. Building and starting the applications

The deployment is executed using:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

---

# Jenkins CI/CD Pipeline

Jenkins is the CI/CD tool used for this project.

The pipeline is defined in:

```text
Jenkinsfile
```

The Jenkins pipeline performs the following stages:

### 1. Checkout Code

Jenkins retrieves the latest source code from GitHub.

### 2. Build Java Application

Maven builds the Java application and creates the WAR package.

### 3. Terraform Init

Terraform initializes the project and connects to HCP Terraform.

### 4. Terraform Apply

Terraform provisions or verifies the AWS infrastructure.

### 5. Get EC2 Public IP

Jenkins retrieves the EC2 public IP address from Terraform.

### 6. Create Ansible Inventory

Jenkins dynamically creates the Ansible inventory using the EC2 public IP.

### 7. Deploy with Ansible

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
    |
    +----> Terraform
    |          |
    |          v
    |        AWS
    |
    +----> Ansible
               |
               v
          Docker Compose
             /      \
            /        \
           v          v
      Portfolio     Java App
        :80          :8081
```

---

# Application URLs

After successful deployment, the applications are available at:

### Portfolio

```text
http://<EC2-PUBLIC-IP>/
```

### Java Application

```text
http://<EC2-PUBLIC-IP>:8081/sampleapp/
```

---

# Deployment Verification

A successful Jenkins deployment should complete with:

```text
Deployment completed successfully!
```

The Ansible deployment should show:

```text
ok=9
unreachable=0
failed=0
```

Terraform should report:

```text
No changes. Your infrastructure matches the configuration.
```

The Java Maven build should report:

```text
BUILD SUCCESS
```

---

# Security

Sensitive information is not stored directly in the GitHub repository.

The following should remain private:

* AWS access keys
* HCP Terraform API tokens
* SSH private keys
* Passwords
* Other authentication credentials

Jenkins credentials are used to securely provide required secrets during the pipeline.

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
* Web application deployment
* Cloud infrastructure automation

---

# Project Outcome

The completed project provides an automated DevOps workflow capable of taking application code from GitHub, building the Java application, managing AWS infrastructure with Terraform, configuring the EC2 server with Ansible, and deploying two containerized applications using Docker Compose.

The final environment runs both the Portfolio Web Application and Java Web Application on the same AWS EC2 server.

---

# Conclusion

This project demonstrates how multiple DevOps technologies can be integrated into a single automated deployment pipeline.

By combining GitHub, Jenkins, Terraform, AWS, Ansible, Docker, Docker Compose, and Maven, the deployment process becomes repeatable and automated instead of relying on manual server configuration and application deployment.
