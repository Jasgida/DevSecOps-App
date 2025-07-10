# DevSecOps-App
🔖 Recommended Project Description: DevSecOps Flask App with CI/CD, Docker, and Jenkins  This project demonstrates a complete DevSecOps pipeline built from scratch using:  🐍 Flask web application (Python)  ⚙️ Jenkins for CI/CD  🐳 Docker for containerization  🛡 Trivy for container image vulnerability scanning  🔗 GitHub Webhooks for automation

# 🚀 DevSecOps-App

**DevSecOps Flask App with CI/CD, Docker, Jenkins & Security Scanning**

This project demonstrates a complete DevSecOps pipeline built from scratch using:

- 🐍 **Flask** – Python web application framework  
- ⚙️ **Jenkins** – Continuous Integration & Delivery  
- 🐳 **Docker** – Containerization of application  
- 🛡 **Trivy** – Vulnerability scanning for Docker images  
- 🔗 **GitHub Webhooks** – For triggering automated builds  
- ☁️ **AWS EC2 (Ubuntu)** – Hosting the entire pipeline  
- 🧪 **Pytest** – Unit testing framework  

---

## 📦 Tech Stack

| Category           | Technology                        |
|-------------------|------------------------------------|
| Backend            | [Flask](https://flask.palletsprojects.com/) (Python) |
| CI/CD              | [Jenkins](https://www.jenkins.io/) |
| Containerization   | [Docker](https://www.docker.com/) |
| Security Scanning  | [Trivy](https://aquasecurity.github.io/trivy/) |
| Testing            | [Pytest](https://docs.pytest.org/) |
| Hosting            | AWS EC2 (Ubuntu) + Custom VPC     |
| Source Control     | Git + GitHub                      |

---

## 📁 Project Structure

devsecops-app/
├── app/ # Flask app source
│ └── main.py
├── tests/ # Unit tests
│ └── test_main.py
├── trivy-report/ # Trivy vulnerability scan reports
├── Dockerfile # Docker container specification
├── Jenkinsfile # CI/CD pipeline configuration
├── requirements.txt # Python dependencies
├── README.md # Project documentation
└── LICENSE # MIT License

---

## ⚙️ Key Features

- ✅ End-to-end CI/CD pipeline via Jenkins
- ✅ Dockerized Flask web application
- ✅ GitHub webhook integration for auto-triggering builds
- ✅ Trivy scan for vulnerability detection in Docker images
- ✅ Unit tests with Pytest
- ✅ Full deployment within a secure AWS EC2 instance

---

## 🔁 CI/CD Pipeline Flow

```groovy
pipeline {
    agent any
    stages {
        Checkout
        Install Dependencies
        Run Tests
        Build Docker Image
        Run Trivy Scan
        Deploy to EC2
    }
}
✅ Trigger:
GitHub → Jenkins Webhook → CI/CD Pipeline → Auto Deploy

🚀 How to Use
🧪 Run Locally (for development)

# Install dependencies
pip install -r requirements.txt

# Run Flask app
python app/main.py
Visit: http://localhost:5000

🌍 Deployment Output
Once deployed on EC2:

http://<your-ec2-public-ip>:5000
📄 License
This project is licensed under the MIT License.
See LICENSE for full details.

🙋 Author
David Jasgida
🔗 GitHub Profile
💼 DevOps Engineer | 💡 Passionate about automation, cloud, and security

🧠 Project Goal
This project was developed to showcase real-world DevSecOps practices — combining continuous integration, containerization, automated testing, and vulnerability scanning.
It is intended for use in technical interviews, portfolio demonstrations, and as a blueprint for scalable and secure pipelines.
