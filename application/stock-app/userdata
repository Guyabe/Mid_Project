#!/bin/bash
# Update system packages
yum update -y

# Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to the docker group so you can run docker without sudo
usermod -aG docker ec2-user

# Pull the stock-app Docker image from Docker Hub
docker pull gabecasis/stock-app:2

# Run the stock-app container, exposing Flask on port 5001 and metrics on port 8000
docker run -d -p 5001:5001 -p 8000:8000 gabecasis/stock-app:2
