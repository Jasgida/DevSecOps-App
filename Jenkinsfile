pipeline {
    agent any

    environment {
        IMAGE_NAME = 'devsecops-app'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                  branches: [[name: '*/main']],
                  userRemoteConfigs: [[url: 'https://github.com/Jasgida/DevSecOps-App.git']]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker-compose run --rm devsecops-app-test'
            }
        }

        stage('Push Docker Image') {
            when {
                expression { env.DOCKERHUB_USERNAME != null && env.DOCKERHUB_PASSWORD != null }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    script {
                        def tag = BRANCH_NAME.toLowerCase()
                        def dockerTag = "${IMAGE_NAME}:${tag}"
                        sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
                        sh "docker tag ${IMAGE_NAME}:latest ${dockerTag}"
                        sh "docker push ${dockerTag}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace after build'
            cleanWs()
        }
        failure {
            echo 'Build failed, check logs!'
        }
    }
}
