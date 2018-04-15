#!/bin/bash

# Created By Diogo A. M. Barbosa 2018

# Update System
sudo apt-get update

# Install packages
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

# Download Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Insert the Key
sudo apt-key fingerprint 0EBFCD88

# Insert Repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update system
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce -y

# Download Package
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

# Initial package
sudo chmod +x /usr/local/bin/docker-compose

# Build first stack
docker-compose run web rails new . --force --database=mysql

# Build new Docker image
docker-compose build

# setting permissions
sudo chown -R root:root . 

# edit this file database.yml
mv config/database.yml config/database.old

sed 's/localhost/db/g' config/database.old > config/database.new

sed 's/password:/password: "root"/g' config/database.new > config/database.yml

# up stack
docker-compose up
# create database
docker-compose run web rake db:create

docker-compose up -d





