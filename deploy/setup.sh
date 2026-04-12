#!/bin/bash
# ============================================
# scribble Blog Platform - EC2 Setup Script
# Run this script on a Ubuntu EC2 instance
# ============================================

set -e

echo "Setting up scribble Blog Platform..."

# --- Update system ---
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# --- Install Node.js 20.x ---
echo "Installing Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# --- Install PostgreSQL ---
echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

# --- Install Nginx ---
echo "Installing Nginx..."
sudo apt install -y nginx

# --- Install PM2 (process manager) ---
echo "Installing PM2..."
sudo npm install -g pm2

# --- Configure PostgreSQL ---
echo "Configuring PostgreSQL..."
sudo -u postgres psql <<EOF
CREATE USER scribble_user WITH PASSWORD 'scribble_pass_2026';
CREATE DATABASE scribble_db OWNER scribble_user;
GRANT ALL PRIVILEGES ON DATABASE scribble_db TO scribble_user;
\c scribble_db
GRANT ALL ON SCHEMA public TO scribble_user;
EOF

echo "PostgreSQL configured"

# --- Set up project directory ---
echo "Setting up project..."
sudo mkdir -p /var/www/scribble
sudo chown -R $USER:$USER /var/www/scribble

# Copy project files to /var/www/scribble/
cp -r ~/scribble/* /var/www/scribble/

# --- Install backend dependencies ---
echo "Installing backend dependencies..."
cd /var/www/scribble/backend
npm install --production

# --- Build frontend ---
echo "Building frontend..."
cd /var/www/scribble/frontend
npm install
npm run build

# --- Configure Nginx ---
echo "Configuring Nginx..."
sudo cp /var/www/scribble/deploy/scribble-nginx.conf /etc/nginx/sites-available/scribble
sudo ln -sf /etc/nginx/sites-available/scribble /etc/nginx/sites-enabled/scribble
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# --- Start backend with PM2 ---
echo "Starting backend with PM2..."
cd /var/www/scribble/backend
pm2 start src/index.js --name scribble-backend
pm2 save
pm2 startup systemd -u $USER --hp /home/$USER | tail -1 | sudo bash

echo ""
echo "==========================================="
echo "scribble is now live!!!!"
echo "==========================================="
echo ""
echo "Access your blog at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo '<your-ec2-public-ip>')"
echo ""