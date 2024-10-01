#!/bin/bash
# Update system packages
yum update -y

# Install Docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# Create a directory for the project
mkdir -p /home/ec2-user/stock-app
mkdir -p /home/ec2-user/promtail /home/ec2-user/promtail/config
mkdir -p /home/ec2-user/loki/data /home/ec2-user/loki/config

# Create the Promtail configuration file
cat <<EOF > /home/ec2-user/promtail/config/config.yml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /var/log/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log

  # New job to scrape logs locally from stock-app
  - job_name: stock-app-logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: stock-app-logs
          __path__: /home/ec2-user/stock-app/logs/*.log
EOF

# Create the Docker Compose file
cat <<EOF > /home/ec2-user/docker-compose.yml
version: '3'
services:
  promtail:
    image: gabecasis/promtail:2
    container_name: promtail
    ports:
      - "9080:9080"
    volumes:
      - ./promtail/config/config.yml:/etc/promtail/config.yml
      - /home/ec2-user/stock-app/logs:/home/ec2-user/stock-app/logs  # Correctly map stock-app logs for Promtail
    networks:
      - app-network

  stock-app:
    image: gabecasis/stock-app:5
    ports:
      - "5001:5001"
      - "8000:8000"
    environment:
      MONGO_URI: ${MONGO_URI}
    volumes:
      - /home/ec2-user/stock-app/logs:/app/logs  # Maps the container’s logs directory to a host directory
    command: ["--mongo_uri", "${MONGO_URI}"]
    networks:
      - app-network

  loki:
    image: grafana/loki:latest
    container_name: loki
    ports:
      - "3100:3100"
    networks:
      - app-network
    restart: always

networks:
  app-network:
    driver: bridge
EOF

# Set MongoDB URI variable (using the MongoDB EC2 IP 3.237.173.0 and appropriate credentials)
MONGO_URI="mongodb://root:password@3.237.173.0:27017/"

# Pull the latest Docker images
sudo docker-compose pull

# Run docker-compose with MONGO_URI passed as an environment variable
sudo MONGO_URI=$MONGO_URI docker-compose up -d
