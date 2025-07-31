pipeline {
    agent any

    environment {
        IMAGE_NAME = 'jasgida/devsecops-flask-app'
        TRIVY_CACHE_DIR = "${env.WORKSPACE}/trivycache"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Jasgida/DevSecOps-App.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r app/requirements.txt
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
                sh '''
                    docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    mkdir -p $TRIVY_CACHE_DIR
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                        -v $TRIVY_CACHE_DIR:/root/.cache/ -v /tmp:/tmp \
                        aquasec/trivy image --exit-code 0 --severity MEDIUM,HIGH,CRITICAL $IMAGE_NAME
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy (Optional)') {
            steps {
                echo 'Deploy stage (optional). Add deployment script here.'
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

