#!/bin/bash

set -e
set -x

sudo apt update
sudo apt install -y unzip curl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Step 1: Request a metadata session token (valid for 6 hours)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Step 2: Use that token to securely access instance metadata
MY_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

# Set environment variables
# export NEXT_PUBLIC_APIURL="__next_public_apiurl__"
export NEXT_PUBLIC_APIURL="http://$(curl -H "X-aws-ec2-metadata-token: $(curl -X PUT http://169.254.169.254/latest/api/token \
                                                                              -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")" \
                                                                              http://169.254.169.254/latest/meta-data/local-ipv4):8000/api"
export DB_HOST="${db_host}"
export DB_PORT="${db_port}"
export DB_NAME="${db_name}"
export DB_USER="${db_user}"
export DB_PASSWORD="${db_password}"
export DB_TYPE="${db_type}"
export CLIENT_URL="${client_url}"

echo "NEXT_PUBLIC_APIURL=http://${MY_IP}:8000/api" >> /etc/environment
echo "DB_HOST=$DB_HOST"
echo "DB_PORT=$DB_PORT"
echo "DB_NAME=$DB_NAME"
echo "DB_USER=$DB_USER"
echo "DB_PASSWORD=$DB_PASSWORD"
echo "DB_TYPE=$DB_TYPE"
echo "CLIENT_URL=$CLIENT_URL"

# Install Docker
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update -y
sudo apt install -y docker-ce
sudo systemctl is-active --quiet docker && echo "Docker is running" || echo "Docker is not running"
sudo usermod -aG docker ubuntu

# Clone repo
git clone https://github.com/EphraimX/roi-calculator.git
cd roi-calculator

# Frontend
cd client-side
docker build \
  -f Dockerfile.dev \
  --build-arg NEXT_PUBLIC_APIURL=$NEXT_PUBLIC_APIURL \
  -t roi-calculator-frontend .
docker run -d -p 80:3000 roi-calculator-frontend

# Backend
cd ../server-side
docker run -d \
  --name roi-calculator-backend \
  -e DB_HOST=$DB_HOST \
  -e DB_PORT=$DB_PORT \
  -e DB_NAME=$DB_NAME \
  -e DB_USER=$DB_USER \
  -e DB_PASSWORD=$DB_PASSWORD \
  -e DB_TYPE=$DB_TYPE \
  -e CLIENT_URL=$CLIENT_URL \
  -p 8000:8000 \
  ephraimx57/roi-calculator-backend

# Monitoring
cd ../monitoring
docker compose -f monitoring-docker-compose.yml up -d prometheus cadvisor node_exporter
