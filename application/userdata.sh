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

# Create necessary directories for volumes
mkdir -p /home/ec2-user/prometheus /home/ec2-user/prometheus/config
mkdir -p /home/ec2-user/prometheus/data
mkdir -p /home/ec2-user/grafana
mkdir -p /home/ec2-user/loki/data
mkdir -p /home/ec2-user/promtail

# Change ownership of directories to ec2-user
chown -R ec2-user:ec2-user /home/ec2-user/*

chown -R 65534:65534 /home/ec2-user/prometheus  # Ensure Prometheus has permission to write to the directory


# Create the Prometheus configuration file
cat <<EOF > /home/ec2-user/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['44.222.140.65:9090']
  - job_name: 'loki'
    static_configs:
      - targets: ['44.222.140.65:3100']
EOF

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
EOF

# Change ownership of the Grafana directory to ensure it can be written to by Grafana inside the container
chown -R 472:472 /home/ec2-user/grafana

# Change ownership of all other directories to ec2-user
chown -R ec2-user:ec2-user /home/ec2-user/prometheus /home/ec2-user/loki /home/ec2-user/promtail


# Create Docker Compose file
cat <<EOF > /home/ec2-user/docker-compose.yml
version: '3'
services:
  prometheus:
    image: gabecasis/prometheus:2
    ports:
      - "9090:9090"
    networks:
      - app-network
    restart: always
    volumes:
      - ./prometheus:/prometheus  # Persistent storage for Prometheus data
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  # Custom Prometheus config

  grafana:
    image: gabecasis/grafana:2
    ports:
      - "3000:3000"
    networks:
      - app-network
    restart: always
    volumes:
      - ./grafana:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - loki

  loki:
    image: gabecasis/loki:2
    container_name: loki
    ports:
      - "3100:3100"
    networks:
      - app-network
    restart: always
    volumes:
      - ./loki/data:/loki

  promtail:
    image: gabecasis/promtail:2
    container_name: promtail
    ports:
      - "9080:9080"
    volumes:
      - ./promtail/config/config.yml:/etc/promtail/config.yml
      - ./loki/data:/var/log/loki
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
EOF

# Navigate to the directory and bring up the services
cd /home/ec2-user
docker-compose up -d