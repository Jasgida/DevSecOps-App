pipeline {
    agent any

    environment {
        IMAGE_NAME = 'jasgida/devsecops-app'
        DOCKER_CREDS = credentials('docker-creds')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    apt-get update && apt-get install -y wget apt-transport-https gnupg lsb-release
                    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor -o /usr/share/keyrings/trivy.gpg
                    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/trivy.list
                    apt-get update && apt-get install -y trivy
                    trivy image --exit-code 0 --severity LOW,MEDIUM $IMAGE_NAME
                    trivy image --exit-code 1 --severity HIGH,CRITICAL $IMAGE_NAME || echo "High/Critical vulnerabilities found"
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy (Optional)') {
            steps {
                echo 'Deploy step would go here (e.g., docker-compose up or kubectl apply)'
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Please check logs.'
        }
    }
}

