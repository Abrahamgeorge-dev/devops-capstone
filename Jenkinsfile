pipeline {
    agent any

    environment {
        TF_TOKEN_app_terraform_io = credentials('hcp-terraform-token')
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Java Application') {
            steps {
                sh '''
                    mvn -f java-app/pom.xml clean package -DskipTests
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform -chdir=terraform init
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform -chdir=terraform apply -auto-approve
                '''
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    env.EC2_IP = sh(
                        script: 'terraform -chdir=terraform output -raw ec2_public_ip',
                        returnStdout: true
                    ).trim()

                    echo "EC2 Public IP: ${env.EC2_IP}"
                }
            }
        }

        stage('Create Ansible Inventory') {
            steps {
                sh '''
                    echo "[webserver]" > ansible/inventory.ini
                    echo "devops-server ansible_host=${EC2_IP} ansible_user=ubuntu" >> ansible/inventory.ini
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ANSIBLE_HOST_KEY_CHECKING=False \
                        ansible-playbook \
                        -i ansible/inventory.ini \
                        ansible/playbook.yml
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully!"
            echo "Portfolio: http://${EC2_IP}/"
            echo "Java App: http://${EC2_IP}:8081/"
        }

        failure {
            echo "Deployment failed. Check the Jenkins console output."
        }
    }
}

