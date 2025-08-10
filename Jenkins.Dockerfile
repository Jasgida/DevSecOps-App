FROM jenkins/jenkins:lts

USER root

# Install dependencies for Docker CLI
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Create docker group with host's docker GID (default 999, adjust if different)
RUN groupadd -g 999 docker || true && \
    usermod -aG docker jenkins

# Set up Jenkins workspace and permissions
RUN mkdir -p /var/jenkins_home/workspace && \
    chown -R jenkins:jenkins /var/jenkins_home

USER jenkins

# Jenkins will start with its default entrypoint

