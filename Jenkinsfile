pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-ecr')[0]
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-ecr')[1]
        ECR_URL = "546798745265.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {
        stage('Checkout') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-ecr']]) {

                // Checking out the code from the specified GitHub repository and branch
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[url: 'https://github.com/gfakx/JavaApp-Jenkins-Docker-ECR-EKS.git']]
                ])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-ecr']]) {
                sh 'docker build -t spring-petclinic:latest .'
                }
            }
        }

        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-ecr']]) {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL"
                sh "docker tag spring-petclinic:latest $ECR_URL/spring-petclinic:latest"
                sh "docker push $ECR_URL/spring-petclinic:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-ecr']]) {
                sh 'kubectl apply -f spring-petclinic-deployment.yaml'
                sh 'kubectl apply -f spring-petclinic-service.yaml'
                }
            }
        }
    }
}
