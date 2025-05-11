#!/bin/bash
set -e

# --- Set AWS CLI default region ---
export AWS_DEFAULT_REGION=us-east-1

# --- System setup ---
sudo yum update -y
sudo yum install -y python3 git nginx awscli

# Ensure pip is available
sudo python3 -m ensurepip
sudo pip3 install --upgrade pip

# --- App setup ---
APP_DIR="/opt/trade-tracker"
sudo git clone https://github.com/immortaldogg/trade-tracker.git $APP_DIR
cd $APP_DIR/backend

# --- Python venv setup ---
sudo python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# --- Fetch secrets from SSM ---
DB_USER=$(aws ssm get-parameter --name "/trade-tracker/DB_USER" --with-decryption --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/trade-tracker/DB_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
DB_HOST=$(aws ssm get-parameter --name "/trade-tracker/DB_HOST" --with-decryption --query "Parameter.Value" --output text)
DB_PORT=$(aws ssm get-parameter --name "/trade-tracker/DB_PORT" --with-decryption --query "Parameter.Value" --output text)

# --- Write .env file for systemd ---
cat > .env <<EOF
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
EOF

# --- Set correct permissions on .env ---
sudo chown ec2-user:ec2-user .env
sudo chmod 600 .env
sudo chmod +x $APP_DIR/backend/entrypoint.sh

# --- Create systemd service ---
sudo tee /etc/systemd/system/trade-tracker.service > /dev/null <<EOF
[Unit]
Description=Trade Tracker FastAPI App
After=network.target

[Service]
WorkingDirectory=${APP_DIR}/backend
ExecStart=${APP_DIR}/backend/entrypoint.sh
EnvironmentFile=${APP_DIR}/backend/.env
Restart=always
User=ec2-user

[Install]
WantedBy=multi-user.target
EOF

# --- Enable and start the service ---
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable trade-tracker
sudo systemctl start trade-tracker

# --- Nginx reverse proxy ---
sudo systemctl enable nginx
sudo systemctl start nginx

sudo tee /etc/nginx/nginx.conf > /dev/null <<EOF
events {}
http {
    server {
        listen 80;
        server_name _;

        location / {
            proxy_pass http://127.0.0.1:8000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
EOF

sudo nginx -s reload
