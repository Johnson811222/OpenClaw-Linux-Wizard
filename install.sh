#!/bin/bash

# OpenClaw Linux Installation Wizard
set -e

echo "🐧 OpenClaw Linux Installation"

# Check sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "OS: $NAME $VERSION"
fi

# Install dependencies
echo "Installing dependencies..."
if command -v apt &> /dev/null; then
    apt update
    apt install -y nodejs npm python3 git curl
elif command -v yum &> /dev/null; then
    yum install -y nodejs npm python3 git curl
elif command -v dnf &> /dev/null; then
    dnf install -y nodejs npm python3 git curl
elif command -v pacman &> /dev/null; then
    pacman -Sy --noconfirm nodejs npm python git curl
fi

# Install OpenClaw
echo "Installing OpenClaw..."
npm install -g openclaw

# Initialize
echo "Initializing OpenClaw..."
sudo -u $SUDO_USER openclaw init --yes

# Create service
echo "Creating service..."
cat > /etc/systemd/system/openclaw.service << EOF
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=$SUDO_USER
ExecStart=/usr/bin/openclaw start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable openclaw
systemctl start openclaw

echo "✅ Installation complete!"
echo "OpenClaw is now running."
echo "Check status: sudo systemctl status openclaw"
