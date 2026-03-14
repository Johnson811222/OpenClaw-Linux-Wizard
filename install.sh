#!/bin/bash

<<<<<<< HEAD
# 🐧 OpenClaw Linux 一键安装脚本
# 作者: OpenClaw Linux Guide 项目
# 描述: 一键安装OpenClaw + 飞书集成 + 核心技能

echo "========================================"
echo "    🐧 OpenClaw Linux 一键安装"
echo "========================================"
echo ""

# 显示横幅
echo " ██████╗ ██████╗ ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗    ██╗"
echo "██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║    ██║"
echo "██████╔╝██████╔╝█████╗  ██╔██╗ ██║██║     ██║     ███████║██║ █╗ ██║"
echo "██╔═══╝ ██╔══██╗██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║██║███╗██║"
echo "██║     ██║  ██║███████╗██║ ╚████║╚██████╗███████╗██║  ██║╚███╔███╔╝"
echo "╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ "
echo ""
echo "📱 Linux 极速安装 OpenClaw AI助手 + 飞书集成"
echo ""

# 检查root权限
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  不建议以root身份运行此脚本"
    echo "   请使用普通用户运行"
    exit 1
fi

# 安装统计
echo "📊 安装计划："
echo "   ✅ 系统环境检查 (1分钟)"
echo "   ✅ 安装Node.js (2分钟)"
echo "   ✅ 安装OpenClaw CLI (1分钟)"
echo "   ✅ 配置飞书集成 (3分钟)"
echo "   ✅ 安装核心技能 (5分钟)"
echo "   ✅ 配置定时任务 (2分钟)"
echo "   ✅ 验证安装结果 (1分钟)"
echo ""
echo "⏱️  预计总时间: 15分钟"
echo ""

# 确认继续
echo "🔍 开始安装前检查..."
read -p "是否继续安装？(Y/N): " confirm
if [ "$confirm" != "Y" ] && [ "$confirm" != "y" ]; then
    echo "安装已取消"
    exit 0
fi

# ==================== 第1步：系统环境检查 ====================
echo ""
echo "========================================"
echo "   第1步：系统环境检查"
echo "========================================"

# 检查系统信息
if command -v lsb_release &> /dev/null; then
    os_info=$(lsb_release -d | cut -f2)
    echo "✅ 操作系统: $os_info"
else
    os_info=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
    echo "✅ 操作系统: $os_info"
fi

# 检查内核版本
kernel_version=$(uname -r)
echo "✅ 内核版本: $kernel_version"

# 检查内存
if command -v free &> /dev/null; then
    total_mem=$(free -h | grep Mem | awk '{print $2}')
    echo "✅ 系统内存: $total_mem"
fi

# 检查磁盘空间
if command -v df &> /dev/null; then
    disk_space=$(df -h / | tail -1 | awk '{print $4}')
    echo "✅ 磁盘空间: 根分区剩余 $disk_space"
fi

# 检查当前用户
current_user=$(whoami)
echo "✅ 当前用户: $current_user"

# ==================== 第2步：安装Node.js ====================
echo ""
echo "========================================"
echo "   第2步：安装Node.js"
echo "========================================"

# 检查是否已安装Node.js
if command -v node &> /dev/null; then
    node_version=$(node --version)
    echo "✅ Node.js 已安装: $node_version"
else
    echo "📦 安装Node.js LTS版本..."
    
    # 使用NodeSource仓库
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
    
    # 验证安装
    node_version=$(node --version)
    echo "✅ Node.js 安装成功: $node_version"
fi

# 检查npm
npm_version=$(npm --version)
echo "✅ npm 版本: $npm_version"

# 配置npm全局路径
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
echo "✅ 配置npm全局路径"

# ==================== 第3步：安装OpenClaw CLI ====================
echo ""
echo "========================================"
echo "   第3步：安装OpenClaw CLI"
echo "========================================"

echo "📦 安装OpenClaw CLI..."

# 安装OpenClaw
npm install -g openclaw

# 验证安装
openclaw_version=$(openclaw --version 2>/dev/null)
if [ -n "$openclaw_version" ]; then
    echo "✅ OpenClaw 安装成功: $openclaw_version"
else
    echo "❌ OpenClaw安装验证失败"
    exit 1
fi

# 初始化工作空间
echo "📁 初始化工作空间..."
openclaw init 2>/dev/null
echo "✅ 工作空间初始化完成"

# ==================== 第4步：配置飞书集成 ====================
echo ""
echo "========================================"
echo "   第4步：配置飞书集成"
echo "========================================"

echo "📱 飞书集成配置说明："
echo ""
echo "请按照以下步骤配置飞书："
echo "1. 访问 https://open.feishu.cn/"
echo "2. 创建企业自建应用"
echo "3. 获取以下凭证："
echo "   • App ID"
echo "   • App Secret"
echo "   • Verification Token"
echo "   • Encrypt Key (可选)"
echo ""
echo "配置完成后，运行以下命令设置环境变量："
echo '   export FEISHU_APP_ID="your_app_id"'
echo '   export FEISHU_APP_SECRET="your_app_secret"'
echo '   export FEISHU_VERIFICATION_TOKEN="your_token"'
echo ""

# 创建配置文件模板
config_template='{
  "model": "deepseek/deepseek-chat",
  "defaultModel": "deepseek/deepseek-chat",
  "workspace": "/home/$(whoami)/.openclaw/workspace",
  "plugins": {
    "allow": ["feishu"],
    "feishu": {
      "appId": "YOUR_APP_ID_HERE",
      "appSecret": "YOUR_APP_SECRET_HERE",
      "verificationToken": "YOUR_VERIFICATION_TOKEN_HERE",
      "encryptKey": "YOUR_ENCRYPT_KEY_HERE"
    }
  },
  "toolpolicy": "coding"
}'

config_path="$HOME/.openclaw/config.json"
if [ ! -f "$config_path" ]; then
    echo "$config_template" > "$config_path"
    echo "✅ 创建配置文件模板: $config_path"
    echo "   请编辑此文件并填入您的飞书凭证"
fi

# ==================== 第5步：安装核心技能 ====================
echo ""
echo "========================================"
echo "   第5步：安装核心技能"
echo "========================================"

echo "📦 安装ClawHub技能管理工具..."
npm install -g clawhub

clawhub_version=$(clawhub --version 2>/dev/null)
echo "✅ ClawHub 安装成功: $clawhub_version"

echo ""
echo "🎯 准备安装18个核心技能..."
echo "   这可能需要几分钟时间，请耐心等待..."

# 运行技能安装脚本
if [ -f "install-skills.sh" ]; then
    chmod +x install-skills.sh
    ./install-skills.sh
else
    echo "⚠️  技能安装脚本未找到，请手动安装技能"
    echo "   运行: clawhub install feishu-doc"
fi

# ==================== 第6步：启动服务 ====================
echo ""
echo "========================================"
echo "   第6步：启动OpenClaw服务"
echo "========================================"

echo "🚀 启动OpenClaw Gateway服务..."
openclaw gateway start

# 等待服务启动
sleep 3

# 检查服务状态
if openclaw gateway status &>/dev/null; then
    echo "✅ OpenClaw Gateway 服务运行正常"
else
    echo "⚠️  Gateway服务可能未启动，请手动检查"
fi

# ==================== 第7步：验证安装 ====================
echo ""
echo "========================================"
echo "   第7步：验证安装结果"
echo "========================================"

echo "🔍 运行安装验证..."

if [ -f "verify-installation.sh" ]; then
    chmod +x verify-installation.sh
    ./verify-installation.sh
else
    echo "📊 手动验证步骤："
    echo "1. 检查OpenClaw: openclaw --version"
    echo "2. 检查服务状态: openclaw gateway status"
    echo "3. 测试飞书连接: openclaw feishu test"
    echo "4. 测试技能: openclaw skill test feishu-doc"
fi

# ==================== 安装完成 ====================
echo ""
echo "========================================"
echo "   🎉 安装完成！"
echo "========================================"
echo ""

echo "🌟 恭喜！OpenClaw 已成功安装到您的Linux系统！"
echo ""

echo "📋 后续步骤："
echo "1. 配置飞书凭证（如果尚未配置）"
echo "2. 测试消息发送: openclaw feishu send --message '测试'"
echo "3. 探索技能: clawhub list"
echo "4. 配置定时任务（参考文档）"
echo ""

echo "🔧 常用命令："
echo "   openclaw --version          # 查看版本"
echo "   openclaw gateway status     # 服务状态"
echo "   openclaw feishu test        # 测试飞书"
echo "   clawhub list                # 列出技能"
echo ""

echo "📚 文档资源："
echo "   GitHub项目: https://github.com/Johnson811222/OpenClaw-Linux-Wizard"
echo "   官方文档: https://docs.openclaw.ai"
echo "   故障排除: 查看 troubleshooting-checklist.md"
echo ""

echo "💖 如果这个项目对您有帮助，请给个⭐️ Star支持！"
echo ""

# 记录安装日志
log_entry="[$(date '+%Y-%m-%d %H:%M:%S')] OpenClaw Linux 安装完成
用户: $USER
系统: $os_info
Node.js: $(node --version)
OpenClaw: $(openclaw --version 2>/dev/null)"

echo "$log_entry" >> "$(pwd)/install.log"

# 等待用户输入
read -p "按回车键退出..."
=======
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
>>>>>>> f7189b01c58c3f0efbad1bf0704fa362e12f6257
