FROM jenkins/jenkins:lts

USER root

# Install dependencies and set up Docker repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg lsb-release && \
    # Remove conflicting containerd packages
    apt-get remove -y containerd runc || true && \
    # Download Docker GPG key with retry logic
    (curl -fsSL https://download.docker.com/linux/debian/gpg -o /tmp/docker-archive-keyring.gpg || \
     (sleep 2 && curl -fsSL https://download.docker.com/linux/debian/gpg -o /tmp/docker-archive-keyring.gpg) || \
     (sleep 4 && curl -fsSL https://download.docker.com/linux/debian/gpg -o /tmp/docker-archive-keyring.gpg)) && \
    cat /tmp/docker-archive-keyring.gpg | gpg --dearmor --batch --yes -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    rm /tmp/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    # Install docker-ce-cli
    apt-get install -y --no-install-recommends docker-ce-cli && \
    # Install docker-compose
    curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    # Install trivy for security scanning
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.56.2 && \
    rm -rf /var/lib/apt/lists/*

# Create docker group with host's docker GID (default 999, adjust if different)
RUN groupadd -g 113 docker || true && \
    usermod -aG docker jenkins

# Set up Jenkins workspace and permissions
RUN mkdir -p /var/jenkins_home/workspace && \
    chown -R jenkins:jenkins /var/jenkins_home

USER jenkins

# Jenkins will start with its default entrypoint
