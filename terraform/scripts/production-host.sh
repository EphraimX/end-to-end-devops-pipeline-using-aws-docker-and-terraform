#!/bin/bash

# Set environment variables
export NEXT_PUBLIC_APIURL="__next_public_apiurl__"
export DB_HOST="__db_host__"
export DB_PORT="__db_port__"
export DB_NAME="__db_name__"
export DB_USER="__db_user__"
export DB_PASSWORD="__db_password__"
export DB_TYPE="__db_type__"
export CLIENT_URL="__client_url__"

echo "NEXT_PUBLIC_APIURL=$NEXT_PUBLIC_APIURL"
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
sudo usermod -aG docker $USER

# Clone repo
git clone https://github.com/EphraimX/roi-calculator.git
cd roi-calculator

# Frontend
cd client-side
docker build --build-arg NEXT_PUBLIC_APIURL=$NEXT_PUBLIC_APIURL -t roi-calculator-frontend .
docker run -d -p 8080:80 roi-calculator-frontend

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
