#!/bin/bash

# Stopping and deleting the PM2 process
echo "Stopping PM2 process..."
pm2 stop 0
pm2 delete 0

echo "Saving uploads to root directory..."
sudo rm -rf uploads
cp -r QQ-Backend/uploads .

# Removing old directories
echo "Removing old directories..."
sudo rm -rf QQ-Backend
sudo rm -rf current
sudo rm -rf source

# Cloning the repository - Replace <URL> with your repository URL
# Ensure you've set up Git SSH or credential caching if you're not embedding the PAT directly
echo "Cloning repository..."
git clone https://Your-PAT@github.com/DigniteStudios/QQ-Backend.git

echo "Copying uploads to QQ-Backend"
cp -r uploads/ QQ-Backend/

# Installing dependencies
echo "Installing npm dependencies..."
cd QQ-Backend || exit
npm install

# Setting environment variables
cd ..
sudo cp .env QQ-Backend/.env
cd QQ-Backend

# Starting the app with PM2
echo "Starting the app with PM2..."
pm2 start index.js
pm2 save