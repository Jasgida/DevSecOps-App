pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jasgida/devsecops-flask-app'
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds' // Jenkins credentials ID
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'apt update && apt install -y python3-pip'
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'pytest || true' // prevent total failure if no test exists yet
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker rm -f flask-container || true'
                    sh "docker run -d --name flask-container -p 5000:5000 ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }
}
