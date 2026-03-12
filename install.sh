#!/bin/bash

# OpenClaw Linux Installation Wizard
# Complete automated installation with Feishu integration

set -e

echo ""
echo "================================================"
echo "🐧 OpenClaw Linux Installation Wizard"
echo "================================================"
echo "🚀 Complete automated installation with Feishu integration"
echo ""

# Check sudo
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run with sudo: sudo bash install.sh"
    exit 1
fi

echo "✅ Running with appropriate privileges"

# Detect OS
echo "🔍 Detecting Linux distribution..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "✅ Detected: $PRETTY_NAME"
else
    echo "❌ Cannot detect Linux distribution"
    exit 1
fi

# Install dependencies
echo ""
echo "📦 Installing system dependencies..."

case $ID in
    ubuntu|debian|linuxmint|pop)
        apt-get update
        apt-get install -y nodejs npm python3 python3-pip git curl wget
        ;;
    
    centos|rhel|rocky|almalinux|fedora)
        if command -v dnf &> /dev/null; then
            dnf install -y nodejs npm python3 python3-pip git curl wget
        else
            yum install -y nodejs npm python3 python3-pip git curl wget
        fi
        ;;
    
    arch|manjaro)
        pacman -Sy --noconfirm nodejs npm python python-pip git curl wget
        ;;
    
    *)
        echo "⚠️  Unsupported OS: $ID"
        echo "Please install manually: Node.js, npm, Python, Git"
        exit 1
        ;;
esac

echo "✅ Dependencies installed"

# Install OpenClaw
echo ""
echo "🚀 Installing OpenClaw AI assistant..."
npm install -g openclaw

# Verify installation
if command -v openclaw &> /dev/null; then
    VERSION=$(openclaw --version 2>/dev/null || echo "1.0+")
    echo "✅ OpenClaw installed (v$VERSION)"
else
    echo "❌ OpenClaw installation failed"
    exit 1
fi

# Initialize OpenClaw with Feishu integration
echo ""
echo "⚙️  Initializing OpenClaw with Feishu integration..."
ORIGINAL_USER=${SUDO_USER:-$USER}
sudo -u $ORIGINAL_USER openclaw init --yes --feishu --auto-configure

echo "✅ OpenClaw initialized with Feishu integration"

# Create systemd service
echo ""
echo "🔧 Creating systemd service..."

cat > /etc/systemd/system/openclaw.service << SERVICEEOF
[Unit]
Description=OpenClaw AI Assistant
After=network.target
Wants=network.target

[Service]
Type=simple
User=$ORIGINAL_USER
WorkingDirectory=/home/$ORIGINAL_USER/.openclaw
Environment="PATH=/usr/bin:/usr/local/bin"
ExecStart=/usr/bin/openclaw start
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=openclaw

[Install]
WantedBy=multi-user.target
SERVICEEOF

systemctl daemon-reload
systemctl enable openclaw.service
systemctl start openclaw.service

echo "✅ Systemd service created and started"

# Create health check script
echo ""
echo "📊 Creating health check script..."

mkdir -p /home/$ORIGINAL_USER/.openclaw/scripts

cat > /home/$ORIGINAL_USER/.openclaw/scripts/health-check.sh << HEALTHEOF
#!/bin/bash

echo "🔍 OpenClaw Health Check"
echo "========================"

echo -n "OpenClaw command: "
if command -v openclaw &> /dev/null; then
    echo "✅ Found"
else
    echo "❌ Not found"
fi

echo -n "OpenClaw service: "
if systemctl is-active openclaw.service &> /dev/null; then
    echo "✅ Running"
else
    echo "❌ Not running"
fi

echo -n "Configuration: "
if [ -d ~/.openclaw ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
fi

echo -n "Feishu config: "
if [ -f ~/.openclaw/feishu-config.json ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
fi

echo ""
echo "📊 Status:"
systemctl status openclaw.service --no-pager | head -10
HEALTHEOF

chmod +x /home/$ORIGINAL_USER/.openclaw/scripts/health-check.sh

# Create Feishu configuration guide
echo ""
echo "📱 Creating Feishu configuration guide..."

cat > /home/$ORIGINAL_USER/.openclaw/feishu-guide.md << FEISHUGUIDEEOF
# Feishu Integration Guide

## Configuration Status
✅ OpenClaw has been initialized with Feishu integration
✅ System service is running
✅ Health check script created

## Next Steps for Feishu Setup

### 1. Get Feishu Credentials
1. Go to https://open.feishu.cn/app
2. Create a new application
3. Get your App ID and App Secret

### 2. Configure Feishu in OpenClaw
```bash
# Configure with your credentials
openclaw configure feishu --app-id YOUR_APP_ID --app-secret YOUR_SECRET

# Test the connection
openclaw test feishu
```

### 3. Enable Permissions
In Feishu Developer Platform:
- Enable "Read user information"
- Enable "Send messages"
- Enable "Access documents"
- Enable "Read group chats"

### 4. Verify Integration
```bash
# Check Feishu configuration
cat ~/.openclaw/feishu-config.json

# Restart OpenClaw to apply changes
sudo systemctl restart openclaw

# Check logs for Feishu connection
sudo journalctl -u openclaw -n 20 --no-pager
```

### 5. Test Features
- Send a message to your Feishu bot
- Check if OpenClaw responds
- Test document access
- Verify group chat functionality

## Troubleshooting

### If Feishu connection fails:
1. Check credentials: `cat ~/.openclaw/feishu-config.json`
2. Check logs: `sudo journalctl -u openclaw -f`
3. Reset configuration: `openclaw configure --feishu --reset`
4. Re-test: `openclaw test feishu`

### Need Help?
- OpenClaw Docs: https://docs.openclaw.ai
- Discord Community: https://discord.gg/clawd
- Feishu Developer Docs: https://open.feishu.cn/document
FEISHUGUIDEEOF

# Final message
echo ""
echo "================================================"
echo "🎉 Installation Complete!"
echo "================================================"
echo ""
echo "📊 Installation Summary:"
echo "  • OS: $PRETTY_NAME"
echo "  • OpenClaw: v$VERSION"
echo "  • Service: $(systemctl is-active openclaw.service)"
echo "  • Feishu Integration: ✅ Initialized"
echo "  • Configuration: ~/.openclaw/"
echo ""
echo "🔧 Useful Commands:"
echo "  sudo systemctl status openclaw"
echo "  sudo journalctl -u openclaw -f"
echo "  ~/.openclaw/scripts/health-check.sh"
echo "  openclaw --help"
echo ""
echo "📱 Feishu Setup:"
echo "  Check ~/.openclaw/feishu-guide.md for complete setup instructions"
echo ""
echo "📖 Documentation: https://docs.openclaw.ai"
echo "💬 Community: https://discord.gg/clawd"
echo ""
echo "================================================"
echo "🚀 Your OpenClaw AI assistant is ready!"
echo "================================================"
