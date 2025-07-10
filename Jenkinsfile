pipeline {
    agent any

    environment {
        IMAGE_NAME = 'devsecops-app'
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
    }

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

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

        stage('Push Docker Image') {
            steps {
                sh '''
                echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                docker tag $IMAGE_NAME $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh '''
                if ! command -v trivy >/dev/null; then
                  echo "Installing Trivy..."
                  wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.51.1_Linux-64bit.deb
                  sudo dpkg -i trivy_0.51.1_Linux-64bit.deb
                fi
                trivy image $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
                '''
            }
        }

        stage('Run App') {
            steps {
                sh 'docker run -d -p 5000:5000 $DOCKERHUB_USERNAME/$IMAGE_NAME:latest'
            }
        }
    }
}

