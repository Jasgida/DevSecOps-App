pipeline {
    agent any

    environment {
        IMAGE_NAME = "jasgida/devsecops-app"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'pytest tests/test_app.py'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Scan Image for Vulnerabilities') {
            steps {
                sh 'trivy image $IMAGE_NAME || true'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    """
                }
            }
        }
    }
}

