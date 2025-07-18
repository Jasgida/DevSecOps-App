FROM jenkins/jenkins:lts

USER root

# Install Docker and Python tools
RUN apt-get update && apt-get install -y \
    docker.io \
    python3 \
    python3-pip \
    curl && \
    pip3 install --break-system-packages pytest && \
    apt-get clean

# Add Jenkins to the Docker group
RUN usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

