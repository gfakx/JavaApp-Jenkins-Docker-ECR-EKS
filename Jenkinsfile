pipeline {
    agent any

    environment {
        ECR_URL = "546798745265.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {
        stage('Checkout') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'jenkins-ecr']]) {
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
                sh 'sudo docker build -t spring-petclinic:latest .'
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
                withCredentials([file(credentialsId: 'eks-kubeconfig', variable: 'KUBECONFIG'),
                         string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY'),
                         string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_KEY')]) {
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
                kubectl apply -f spring-petclinic-deployment.yaml -v=9
                '''
            }
         }
        }
    }
}
