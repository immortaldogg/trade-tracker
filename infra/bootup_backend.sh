#!/bin/bash
set -e

# --- System setup ---
apt-get update
apt-get install -y docker.io git ufw

# Enable Docker at boot
systemctl enable docker
systemctl start docker

# --- App setup ---
APP_DIR="/opt/trade-tracker"
git clone https://github.com/immortaldogg/trade-tracker.git $APP_DIR
cd $APP_DIR/backend

DB_USER=$(aws ssm get-parameter --name "/trade-tracker/DB_USER" --with-decryption --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/trade-tracker/DB_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
DB_HOST=$(aws ssm get-parameter --name "/trade-tracker/DB_HOST" --with-decryption --query "Parameter.Value" --output text)

# --- Docker build & run ---
docker build -t trade-tracker-backend .

# Run container on port 8000, restart always
docker run -d \
  --name trade-tracker \
  --restart always \
  -p 8000:8000 \
  trade-tracker-backend

# --- Nginx setup for HTTP (no HTTPS) ---
apt-get install -y nginx
ufw allow 'Nginx Full'

cat > /etc/nginx/sites-available/trade-tracker <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

ln -s /etc/nginx/sites-available/trade-tracker /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx