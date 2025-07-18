pipeline {
    agent any

    environment {
        IMAGE_NAME = 'devsecops-app'
        DOCKER_HUB_USERNAME = 'jasgida'
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'pytest tests/test_app.py'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
                        docker push $DOCKER_HUB_USERNAME/$IMAGE_NAME:$TAG
                    '''
                }
            }
        }

        stage('Deploy (Optional)') {
            steps {
                echo 'This is where deployment would happen (e.g., docker-compose up -d)'
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Please check logs.'
        }
        success {
            echo 'Pipeline completed successfully.'
        }
    }
}

