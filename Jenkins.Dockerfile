FROM jenkins/jenkins:lts

USER root

# Install Python and venv
RUN apt-get update && \
    apt-get install -y python3.11 python3.11-venv python3.11-distutils && \
    ln -s /usr/bin/python3.11 /usr/bin/python3 && \
    apt-get clean

USER jenkins

