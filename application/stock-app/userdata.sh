#!/bin/bash
# Update system packages
yum update -y

# Switch to superuser
sudo su

# Install Docker
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker  # Ensure Docker starts on reboot

# Create a directory for the project
mkdir -p /home/ec2-user/stock-app
cd /home/ec2-user/stock-app

# Pull the stock-app Docker image from Docker Hub
docker pull gabecasis/stock-app:3

# Set MongoDB URI variable (modify this with the correct MongoDB EC2 IP and credentials)
MONGO_URI="mongodb://root:password@<EC2 MONGO IP ADDRESS!!!!!!!>:27017/"

# Run the stock-app container, passing the MongoDB URI as an argument
docker run -d \
  -p 5001:5001 -p 8000:8000 \
  gabecasis/stock-app:3 \
  --mongo_uri "$MONGO_URI"
