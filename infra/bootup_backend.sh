#!/bin/bash
set -e

# Update and install system packages
apt-get update
apt-get install -y python3-pip python3-venv nginx certbot python3-certbot-nginx git ufw

# Allow web traffic
ufw allow 'Nginx Full'

# Setup app folder
APP_DIR="/opt/trade-tracker"
git clone https://github.com/immortaldogg/trade-tracker.git $APP_DIR
cd $APP_DIR

# Python venv
cd ./backend
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Create systemd service
cat > /etc/systemd/system/trade-tracker.service <<EOF
[Unit]
Description=Trade Tracker FastAPI Service
After=network.target

[Service]
User=ubuntu
WorkingDirectory=$APP_DIR
ExecStart=$APP_DIR/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable trade-tracker
systemctl start trade-tracker

# Nginx reverse proxy
cat > /etc/nginx/sites-available/trade-tracker <<EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

ln -s /etc/nginx/sites-available/trade-tracker /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

# Optional: Let's Encrypt cert
# certbot --nginx --non-interactive --agree-tos -m your-email@example.com -d your-domain.com
