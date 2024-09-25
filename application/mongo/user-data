#!/bin/bash
sudo yum update
sudo yum install -y docker
sudo systemctl start docker

sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo su

echo "version: '3'

services:
  mongodb:
    container_name: mongodb
    image: mongo
    ports:
      - "27017:27017"
    volumes:
      - mongo-db-vol:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=root
      - MONGO_INITDB_ROOT_PASSWORD=password

  mongo-express:
    container_name: mongo-express
    image: mongo-express
    ports:
      - "8081:8081"
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=root
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb

volumes:
  mongo-db-vol:
    driver: local
" > docker-compose.yml

docker-compose up -d
