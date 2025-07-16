pipeline {
    agent any

    environment {
        IMAGE_NAME = 'devsecops-app'
        DOCKERHUB_REPO = 'jasgida/devsecops-app'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: "*/${env.BRANCH_NAME}"]],
                    userRemoteConfigs: [[url: 'https://github.com/Jasgida/DevSecOps-App.git']]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker-compose run --rm devsecops-app-test'
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                sh '''
                    trivy image --exit-code 0 --severity HIGH,CRITICAL --no-progress devsecops-app || true
                '''
            }
        }

        stage('Push Docker Image to DockerHub') {
            when {
                expression { env.BRANCH_NAME == 'main' }
            }
            steps {
                script {
                    def versionTag = "${DOCKERHUB_REPO}:${env.BUILD_NUMBER}"
                    def latestTag = "${DOCKERHUB_REPO}:latest"
                    sh "docker tag ${IMAGE_NAME} ${versionTag}"
                    sh "docker tag ${IMAGE_NAME} ${latestTag}"
                }

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_PASSWORD'
                )]) {
                    sh '''
                        docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
                        docker push $DOCKERHUB_REPO:${BUILD_NUMBER}
                        docker push $DOCKERHUB_REPO:latest
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

