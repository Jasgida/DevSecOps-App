pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'jasgida/devsecops-app:11'
    }
    stages {
        stage('Setup') {
            steps {
                sh 'docker --version'
                sh 'docker-compose --version'
                sh 'trivy --version'
            }
        }
        stage('Checkout Main') {
            steps {
                cleanWs()
                git branch: 'main', url: 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }
        stage('Build & Test') {
            steps {
                script {
                    sh 'docker-compose -f docker-compose.yml build app'
                    sh 'docker run --rm ${DOCKER_IMAGE} ls -la /app /app/app /app/tests'
                    sh '''
                        docker run --rm -e PYTHONPATH=/app -e PATH=/home/appuser/.local/bin:$PATH ${DOCKER_IMAGE} pytest tests/ -v --import-mode=importlib --cache-clear || {
                            echo "Tests failed. Check pytest output above for details."
                            exit 1
                        }
                    '''
                }
            }
        }
        stage('Security Scan') {
            steps {
                sh '''
                    trivy image --exit-code 1 --severity CRITICAL --ignorefile .trivyignore ${DOCKER_IMAGE} || {
                        echo "Security scan found critical vulnerabilities. Review Trivy output."
                        exit 1
                    }
                '''
                sh 'trivy fs --scanners misconfig ./app'
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker tag ${DOCKER_IMAGE} jasgida/devsecops-app:latest'
                    sh 'docker push ${DOCKER_IMAGE}'
                    sh 'docker push jasgida/devsecops-app:latest'
                    sh 'docker stop devsecops-app-main || true'
                    sh 'docker rm devsecops-app-main || true'
                    sh 'docker-compose -f docker-compose.yml up -d --remove-orphans'
                }
            }
        }
    }
    post {
        always {
            cleanWs()
            sh 'docker system prune -af'
        }
    }
}
