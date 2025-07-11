pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Jasgida/DevSecOps-App.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    docker.image('python:3.11').inside {
                        sh 'pip install -r requirements.txt'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image('python:3.11').inside {
                        sh 'pytest'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("jasgida/devsecops-app")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-credentials', url: '']) {
                    dockerImage.push('latest')
                }
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 5000:5000 jasgida/devsecops-app'
            }
        }
    }
}

