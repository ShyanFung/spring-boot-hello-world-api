#!/bin/bash

###############################################################################
## Install: Setup docker client on WSL (Windows Subsystem Linux) ubuntu.
## Dependency: Docker for Windows & Windows Ubuntu shell as WSL.
##
## As of Date: Dec. 3, 2018
## Ref: https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly
## Note: Notice channel set to 'edge'. WSL not yet at stable.
###############################################################################

# Environment variables you need to set so you don't have to edit the script below.
export DOCKER_CHANNEL=edge
export DOCKER_COMPOSE_VERSION=1.23.0

# Update the apt package index.
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS.
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker's official GPG key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Pick the release channel.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   ${DOCKER_CHANNEL}"

# Update the apt package index.
sudo apt-get update

# Install the latest version of Docker CE.
sudo apt-get install -y docker-ce

# Allow your user to access the Docker CLI without needing root.
sudo usermod -aG docker $USER

# Install Docker Compose.
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose &&
sudo chmod +x /usr/local/bin/docker-compose
