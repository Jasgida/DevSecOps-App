pipeline {
    agent any

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
                sh 'pytest tests/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devsecops-app .'
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh 'trivy image -f json -o trivy-report/report.json devsecops-app || true'
            }
        }

        stage('Run App') {
            steps {
                sh 'docker run -d -p 5000:5000 devsecops-app'
            }
        }
    }
}

