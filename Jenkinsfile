pipeline {
    agent any

    environment {
        IMAGE_NAME = "jasgida/devsecops-flask-app"
        TAG = "latest"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker --version'
                sh 'docker compose version'
                sh 'docker compose build'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker compose run --rm web pytest'
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                sh 'trivy image ${IMAGE_NAME}:${TAG} || true'
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:${TAG}
                        docker push ${IMAGE_NAME}:${TAG}
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace after build...'
            cleanWs()
        }
        failure {
            echo 'Build failed. Please check logs.'
        }
    }
}

