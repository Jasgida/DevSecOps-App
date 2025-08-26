🚀 DevSecOps-App-CICD

Welcome to DevSecOps-App-CICD!
This repository contains a Flask-based web application integrated with a DevSecOps pipeline using Jenkins, Docker, Trivy, and Docker Compose.

The project demonstrates real-world CI/CD practices with automated build, testing, security scanning, and deployment.


📌 Project Overview

Application: A lightweight Flask app serving "Hello, World!" on the root endpoint → http://localhost:5000
.

CI/CD Pipeline: Jenkins manages build, test, scan, and deploy stages automatically.

Containerization: Dockerized using a custom Dockerfile and orchestrated with docker-compose.

Security: Vulnerability scanning integrated with Trivy, ignoring pre-approved critical CVEs.

Deployment Status: ✅ Successfully deployed as of Build #13 (August 15, 2025).

✨ Features

🔹 Automated Build & Test using Pytest

🔹 Security Scanning with Trivy

🔹 Containerized Deployment with Docker Compose

🔹 Health Checks for running containers

🔹 Automated Cleanup of Jenkins workspace & Docker resources

🛠️ Tech Stack

Backend: Flask (Python)

CI/CD: Jenkins

Containerization: Docker
 + Docker Compose

Security: Trivy

Testing: Pytest

📋 Prerequisites

Make sure you have the following installed:

Docker: >= 28.3.3

Docker Compose: >= 2.24.6

Jenkins: >= 2.516.1 (with Pipeline, Docker, and Trivy plugins)

Git

curl (for endpoint testing)

Configure Jenkins:

Set up a Jenkins server at http://localhost:8080.
Install required plugins (Pipeline, Docker, Trivy) via Manage Plugins.
Add Docker Hub credentials (ID: dockerhub-creds) in Manage Jenkins > Manage Credentials > (global).


Build the Project:

Create a Jenkins job named DevSecOps-App-CICD with Pipeline script from SCM.
Set the repository URL to https://github.com/Jasgida/DevSecOps-App.git and branch to main.
Trigger a build using:
bashcurl -X POST http://localhost:8080/job/DevSecOps-App-CICD/build --user davidchukwuemeka.o:<your-api-token>

📂 Project Structure
DevSecOps-App/
│── app/                  # Flask application
│   └── main.py
│
│── tests/                # Pytest test cases
│   └── test_main.py
│
│── trivy-report/         # Security scan reports
│
│── Dockerfile            # Flask app Dockerfile
│── Jenkinsfile           # Jenkins pipeline definition
│── docker-compose.yml    # Orchestration file
│── requirements.txt      # Python dependencies
│── README.md             # Project documentation
│── LICENSE               # License file

Run Locally (Optional):

Build and start the services:
bashdocker-compose up -d --build

Verify the app is running:
bashcurl http://localhost:5000




Usage

Access the deployed Flask app at http://localhost:5000.
Monitor build status in Jenkins at http://localhost:8080/job/DevSecOps-App-CICD.
Check container health:
bashdocker inspect --format='{{.State.Health.Status}}' devsecops-app-main


Pipeline Stages
The Jenkins pipeline includes the following stages:

Setup: Verifies Docker, Docker Compose, and Trivy versions.
Checkout Main: Pulls the latest code from the main branch.
Build & Test: Builds the Docker image and runs Pytest tests.
Security Scan: Scans the image and filesystem with Trivy.
Deploy: Pushes the image to Docker Hub and deploys via Docker Compose.
Post: Cleans the workspace and prunes Docker resources.

Challenges and Resolutions
During development, the following issues were encountered and resolved:

Dependency Conflict (Build #8): Fixed by retaining libsqlite3-0 and removing only unnecessary dev packages.
ModuleNotFoundError (Build #7): Resolved by adjusting the pytest path and adding an init file.
Pytest Cache Permissions (Build #9): Addressed by updating file permissions in the Dockerfile.
Gunicorn PATH Issue (Build #11): Solved by adding the user’s local bin to the PATH.
Credentials Mismatch (Build #10): Corrected by updating the credential ID.
Image Tag Mismatch (Build #9): Fixed by aligning tags across configurations.
Trivy Vulnerabilities (Build #9): Mitigated by ignoring unfixable CVEs.
Email Notification Failure (Build #14): Prevented by removing email notifications.

Contributing
Feel free to fork this repository and submit pull requests. Ensure changes are tested locally before pushing to the dev or test branches, which are synced with main.
📜 License

This project is licensed under the MIT License. See the LICENSE
 file for details.

🙌 Acknowledgments

Special thanks to the open-source community for Flask, Jenkins, Docker, and Trivy.
Built by David Chukwuemeka.O on August 15, 2025, with updates as of August 26, 2025.


