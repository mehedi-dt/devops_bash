#!/bin/bash

echo $(date '+%d/%m/%Y %H:%M:%S')

# Variables
NODE_VERSION=20.18.1
NODE_MAJOR_VERSION=${NODE_VERSION%%.*}  # Extract major version (e.g., 20 from 20.18.1)

# Install Node $NODE_VERSION
echo "Installing Node $NODE_VERSION"
sudo apt update -y
sudo apt install curl -y
curl -sL "https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x" | sudo bash -
sudo apt install -y nodejs
sudo npm install -g n  # n tool is used to control node version
sudo n "$NODE_VERSION"

# sudo npm install -g pnpm
# sudo npm i -g yarn #install yarn
# sudo npm install pm2 -g #install pm2

echo 'Successfully Installed the Dependencies'
echo Node version:
node --version
echo npm version:
npm --version