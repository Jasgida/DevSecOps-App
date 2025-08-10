pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }
    environment {
        DOCKER_IMAGE = "jasgida/devsecops-app"
        BUILD_TAG = "${env.BUILD_NUMBER}"
        COMPOSE_FILE = "docker-compose.yml"
    }
    stages {
        stage('Checkout Main') {
            steps {
                cleanWs()
                git branch: 'main',
                    url: 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

        stage('Build & Test') {
            steps {
                script {
                    // Build app service from docker-compose
                    sh "docker-compose -f ${COMPOSE_FILE} build app"
                    // Run tests inside the container
                    sh "docker run --rm ${DOCKER_IMAGE}:${BUILD_TAG} pytest tests/ -v"
                }
            }
        }

        stage('Security Scan') {
            steps {
                sh """
                    trivy image --exit-code 1 --severity CRITICAL ${DOCKER_IMAGE}:${BUILD_TAG} || true
                    trivy fs --security-checks config ./app || true
                """
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker tag ${DOCKER_IMAGE}:${BUILD_TAG} ${DOCKER_IMAGE}:latest
                        docker push ${DOCKER_IMAGE}:${BUILD_TAG}
                        docker push ${DOCKER_IMAGE}:latest
                        docker-compose -f ${COMPOSE_FILE} up -d
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs()
            sh "docker system prune -af"
        }
    }
}
