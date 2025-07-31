#!/bin/bash

set -e
set -x


sudo apt update
sudo apt install -y unzip curl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Update and install Docker prerequisites
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common git

# Add Docker GPG key and repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Install Docker
sudo apt update -y
sudo apt install -y docker-ce

# Verify Docker is running
sudo systemctl is-active --quiet docker && echo "Docker is running" || echo "Docker is not running"

# Allow current user to run Docker without sudo
sudo usermod -aG docker $USER

# Clone your repo
git clone https://github.com/EphraimX/roi-calculator.git

# Change directory
cd roi-calculator/monitoring

# Build and start the Grafana service from your Docker Compose file
sudo docker compose -f monitoring-docker-compose.yml up -d grafana