pipeline {
    agent {
        docker {
            image 'python:3.10'
            args '-u root:root' // Run as root inside container
        }
    }

    environment {
        IMAGE_NAME = "jasgida/devsecops-app"
        TRIVY_CACHE_DIR = "/var/tmp/trivy"
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                sh 'pytest'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh '''
                mkdir -p $TRIVY_CACHE_DIR
                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                    -v $TRIVY_CACHE_DIR:/root/.cache/ aquasec/trivy:latest image $IMAGE_NAME
                '''
            }
        }

        stage('Run App') {
            steps {
                sh 'docker run -d -p 5000:5000 --name devsecops-app $IMAGE_NAME'
            }
        }
    }
}

