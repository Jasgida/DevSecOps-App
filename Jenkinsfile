pipeline {
    agent any
    environment {
        BUILD_ID = "${env.BUILD_ID}"
    }
    stages {
        stage('Debug Environment') {
            steps {
                sh '''
                    python3 --version || echo "Python not found"
                    pip3 --version || echo "pip not found"
                    docker --version || echo "Docker not found"
                    trivy --version || echo "Trivy not found"
                    docker-compose --version || echo "docker-compose not found"
                    docker info || echo "Docker daemon not accessible"
                    ls -l /var/run/docker.sock || echo "Cannot list docker.sock"
                    whoami || echo "whoami failed"
                    groups || echo "groups failed"
                    pwd || echo "pwd failed"
                    ls -la || echo "ls failed"
                    git --version || echo "Git not found"
                '''
            }
        }
        stage('Checkout Code') {
            steps {
                cleanWs()
                dir("${env.WORKSPACE}") {
                    checkout([$class: 'GitSCM', 
                        branches: [[name: '*/main']], 
                        userRemoteConfigs: [[url: 'https://github.com/Jasgida/DevSecOps-App.git']]])
                    sh '''
                        git init
                        git config --global --add safe.directory ${env.WORKSPACE}
                        git status
                        ls -la
                    '''
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv || { echo "Failed to create virtual env"; exit 1; }
                    ./venv/bin/pip install --upgrade pip || { echo "Failed to upgrade pip"; exit 1; }
                    if [ -f requirements.txt ]; then ./venv/bin/pip install -r requirements.txt pytest; else echo "No requirements.txt found, skipping"; fi
                '''
            }
        }
        stage('Run Tests') {
            steps {
                sh '''
                    export PYTHONPATH=$PWD:$PWD/app
                    if [ -f tests/test_app.py ]; then ./venv/bin/pytest tests/test_app.py --verbose --rootdir=$PWD; else echo "No test_app.py found, skipping tests"; fi
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                sh '''
                    docker-compose build devsecops-app
                    docker tag devsecops-app-devsecops-app jasgida/devsecops-app:$BUILD_ID
                    docker tag devsecops-app-devsecops-app jasgida/devsecops-app:latest
                '''
            }
        }
        stage('Trivy Vulnerability Scan') {
            steps {
                sh '''
                    trivy image --scanners vuln --exit-code 0 --severity LOW,MEDIUM jasgida/devsecops-app:$BUILD_ID || true
                    trivy image --scanners vuln --exit-code 1 --severity HIGH,CRITICAL jasgida/devsecops-app:$BUILD_ID
                '''
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin || { echo "Docker login failed"; exit 1; }
                        docker push jasgida/devsecops-app:$BUILD_ID
                        docker push jasgida/devsecops-app:latest
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                    docker rm -f devsecops-app devsecops-app-test || true
                    docker-compose up -d
                '''
            }
        }
        stage('Health Check') {
            steps {
                sh '''
                    sleep 10  # Wait for containers to start
                    docker-compose ps | grep devsecops-app | grep healthy || (docker-compose logs devsecops-app && exit 1)
                    docker-compose ps | grep devsecops-app-test | grep "Exit 0" || (docker-compose logs devsecops-app-test && exit 1)
                '''
            }
        }
    }
    post {
        always {
            sh '''
                docker-compose down || true
                docker image prune -f || true
            '''
            echo 'Pipeline completed.'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
