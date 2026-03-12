# OpenClaw Linux Wizard 🐧🚀

[English](#english) | [中文](#中文)

---

<a name="english"></a>
## 🚀 OpenClaw Linux Wizard - Your AI Assistant Deployment Expert

### ✨ **One-Click OpenClaw Installation for Linux**

**OpenClaw Linux Wizard** is the ultimate guide and automation toolkit for deploying OpenClaw AI assistant on Linux systems. Get from zero to fully functional AI assistant with Feishu integration in under 15 minutes!

![License](https://img.shields.io/github/license/Johnson811222/OpenClaw-Linux-Wizard)
![Stars](https://img.shields.io/github/stars/Johnson811222/OpenClaw-Linux-Wizard)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%20|%20Debian%20|%20CentOS%20|%20Fedora%20|%20Arch-blue)

### 🎯 **Why Choose This Guide?**

| Feature | Benefit |
|---------|---------|
| **🚀 One-Click Installation** | No technical knowledge required |
| **🔧 Complete Automation** | All core skills automatically installed |
| **💬 Feishu Integration** | Ready-to-use chat integration |
| **⏰ Automated Tasks** | Scheduled tasks and monitoring |
| **🛡️ Security Hardening** | Built-in security checks and optimizations |
| **📊 Verification Tools** | Complete installation validation |

### ⚡ **Quick Start (5 Minutes)**

```bash
# 1. One command installation (Recommended)
curl -fsSL https://raw.githubusercontent.com/Johnson811222/OpenClaw-Linux-Wizard/main/install.sh | sudo bash

# 2. Or download and run
curl -fsSL https://raw.githubusercontent.com/Johnson811222/OpenClaw-Linux-Wizard/main/install.sh -o install-openclaw.sh
chmod +x install-openclaw.sh
sudo ./install-openclaw.sh
```

### 📋 **What You Get**

#### **Complete Installation Package:**
- ✅ **OpenClaw Core** - Latest version with all dependencies
- ✅ **Core Skills** - Feishu, GitHub, Weather, News, etc.
- ✅ **Feishu Integration** - Pre-configured chat and document access
- ✅ **Automation Scripts** - Daily tasks and maintenance
- ✅ **Security Configuration** - Hardened setup for production use
- ✅ **Troubleshooting Guide** - Solutions for common issues

---

<a name="中文"></a>
## 🚀 OpenClaw Linux 向导 - 您的AI助手部署专家

### ✨ **Linux一键安装OpenClaw**

**OpenClaw Linux向导**是在Linux系统上部署OpenClaw AI助手的终极指南和自动化工具包。在15分钟内从零开始获得具有飞书集成的全功能AI助手！

### 🎯 **为什么选择本指南？**

| 功能 | 优势 |
|------|------|
| **🚀 一键安装** | 无需技术知识 |
| **🔧 完全自动化** | 所有核心技能自动安装 |
| **💬 飞书集成** | 即用型聊天集成 |
| **⏰ 自动化任务** | 计划任务和监控 |
| **🛡️ 安全加固** | 内置安全检查和优化 |
| **📊 验证工具** | 完整的安装验证 |

### ⚡ **快速开始（5分钟）**

```bash
# 1. 一键安装（推荐）
curl -fsSL https://raw.githubusercontent.com/Johnson811222/OpenClaw-Linux-Wizard/main/install.sh | sudo bash

# 2. 或下载后运行
curl -fsSL https://raw.githubusercontent.com/Johnson811222/OpenClaw-Linux-Wizard/main/install.sh -o install-openclaw.sh
chmod +x install-openclaw.sh
sudo ./install-openclaw.sh
```

### 📋 **您将获得**

#### **完整的安装包：**
- ✅ **OpenClaw核心** - 最新版本及所有依赖
- ✅ **核心技能** - 飞书、GitHub、天气、新闻等
- ✅ **飞书集成** - 预配置的聊天和文档访问
- ✅ **自动化脚本** - 日常任务和维护
- ✅ **安全配置** - 生产环境加固设置
- ✅ **故障排除指南** - 常见问题解决方案

## 🐧 **支持的Linux系统**

### **完全支持并测试**
- **Ubuntu** 20.04 LTS, 22.04 LTS, 24.04 LTS
- **Debian** 11 (Bullseye), 12 (Bookworm)
- **CentOS** 8, Stream 9
- **Rocky Linux** 8, 9
- **AlmaLinux** 8, 9
- **Fedora** 34, 35, 36, 37, 38
- **Arch Linux** (最新版)

### **社区测试**
- **Linux Mint** 20+, 21+
- **Pop!_OS** 22.04+
- **openSUSE** Leap 15.4+, Tumbleweed
- **Manjaro** (最新版)

## 🔧 **安装脚本功能**

### **完全自动化流程**
安装脚本 `install.sh` 自动执行以下步骤：

1. **✅ 系统检测** - 自动识别Linux发行版
2. **✅ 依赖安装** - 安装所有必需软件包
3. **✅ OpenClaw安装** - 通过npm安装OpenClaw
4. **✅ 飞书配置** - 自动配置飞书集成
5. **✅ 服务设置** - 创建systemd服务自动启动
6. **✅ 安全加固** - 应用安全最佳实践
7. **✅ 验证检查** - 运行健康检查确保安装正确

### **创建的配置文件**
- `~/.openclaw/config.yaml` - OpenClaw主配置
- `~/.openclaw/feishu-config.json` - 飞书集成设置
- `/etc/systemd/system/openclaw.service` - 系统服务文件
- `~/.openclaw/logs/` - 日志目录（带轮转）

## 📱 **飞书集成配置**

### **自动配置**
向导自动完成：
- 🔍 **检测飞书凭证**（如果可用）
- 🔒 **安全令牌存储**（加密格式）
- 🔄 **消息路由配置**（双向通信）
- 📱 **多设备支持**（移动和桌面）

### **飞书配置详情**
```yaml
feishu:
  enabled: true
  app_id: "your_app_id"
  app_secret: "your_app_secret"
  encryption: true
  auto_sync: true
  message_types:
    - text
    - image
    - file
    - voice
  permissions:
    - read_user_info
    - send_messages
    - access_documents
```

### **手动配置（可选）**
```bash
# 手动配置飞书
openclaw configure feishu --app-id YOUR_APP_ID --app-secret YOUR_SECRET

# 测试飞书连接
openclaw test feishu

# 查看飞书配置
cat ~/.openclaw/feishu-config.json
```

## 🛡️ **安全特性**

### **内置安全**
- 🔒 **加密配置** - 敏感数据加密存储
- 👤 **有限权限** - OpenClaw以专用用户运行
- 🛡️ **防火墙规则** - 自动防火墙配置
- 📝 **日志监控** - 安全事件日志启用
- 🔄 **自动更新** - 安全补丁自动应用

### **安全验证**
```bash
# 运行安全审计
sudo ./scripts/security-audit.sh

# 检查漏洞
sudo ./scripts/vulnerability-scan.sh

# 查看安全日志
sudo journalctl -u openclaw -g "security"
```

## 📊 **安装后步骤**

### **验证命令**
```bash
# 检查OpenClaw是否安装
which openclaw
openclaw --version

# 检查服务状态
sudo systemctl status openclaw

# 查看实时日志
sudo journalctl -u openclaw -f

# 运行健康检查
./scripts/health-check.sh
```

### **管理命令**
```bash
# 启动/停止/重启OpenClaw
sudo systemctl start openclaw
sudo systemctl stop openclaw
sudo systemctl restart openclaw

# 启用/禁用自动启动
sudo systemctl enable openclaw
sudo systemctl disable openclaw

# 检查资源使用
./scripts/monitor-resources.sh
```

## 🐛 **故障排除指南**

### **常见问题及解决方案**

#### **问题1：安装因缺少依赖而失败**
```bash
# 手动修复依赖
sudo apt update && sudo apt install -y nodejs npm python3 git curl  # Ubuntu/Debian
sudo yum install -y nodejs npm python3 git curl                    # CentOS/RHEL
sudo dnf install -y nodejs npm python3 git curl                    # Fedora
sudo pacman -Sy --noconfirm nodejs npm python git curl             # Arch
```

#### **问题2：飞书连接问题**
```bash
# 重置飞书配置
openclaw configure --feishu --reset

# 检查飞书凭证
cat ~/.openclaw/feishu-config.json

# 测试连接
openclaw test --feishu
```

#### **问题3：服务无法启动**
```bash
# 检查服务日志
sudo journalctl -u openclaw -n 100 --no-pager

# 检查配置
openclaw validate-config

# 以调试模式重启服务
sudo systemctl restart openclaw
sudo journalctl -u openclaw -f
```

#### **问题4：权限错误**
```bash
# 修复权限
sudo chown -R $USER:$USER ~/.openclaw
sudo chmod 755 ~/.openclaw

# 检查SELinux/AppArmor
sudo setenforce 0  # 临时禁用SELinux (RHEL/CentOS)
sudo aa-status     # 检查AppArmor状态 (Ubuntu/Debian)
```

## 🔄 **更新与维护**

### **更新OpenClaw**
```bash
# 更新到最新版本
sudo npm update -g openclaw

# 更新配置
openclaw update-config
```

### **备份与恢复**
```bash
# 备份配置
./scripts/backup-config.sh

# 从备份恢复
./scripts/restore-config.sh backup_file.tar.gz
```

### **系统维护**
```bash
# 清理旧日志
./scripts/clean-logs.sh

# 检查磁盘空间
./scripts/check-disk.sh

# 监控性能
./scripts/monitor-performance.sh
```

## 📞 **支持与资源**

### **官方资源**
- 📖 **文档**: https://docs.openclaw.ai
- 💬 **社区Discord**: https://discord.gg/clawd
- 🐛 **问题追踪**: https://github.com/Johnson811222/OpenClaw-Linux-Wizard/issues
- 📧 **邮件支持**: support@openclaw.ai

### **社区资源**
- 🌐 **网站**: https://openclaw.ai
- 🐦 **Twitter**: @OpenClawAI
- 📺 **YouTube教程**: OpenClaw频道
- 👥 **用户群组**: 地区性OpenClaw社区

## 🤝 **贡献**

我们欢迎贡献！以下是您可以提供帮助的方式：

### **报告问题**
发现错误？有功能请求？
1. 检查现有问题
2. 创建包含详细信息的新问题
3. 包括系统信息和日志

### **提交代码**
1. Fork仓库
2. 创建功能分支
3. 进行更改并包含测试
4. 提交拉取请求

### **改进文档**
1. Fork仓库
2. 编辑文档文件
3. 提交拉取请求

### **开发设置**
```bash
# 克隆仓库
git clone https://github.com/Johnson811222/OpenClaw-Linux-Wizard.git
cd OpenClaw-Linux-Wizard

# 安装开发依赖
npm install

# 运行测试
npm test

# 构建文档
npm run docs
```

## 📄 **许可证**

本项目采用 **MIT许可证** - 详情请见 [LICENSE](LICENSE) 文件。

### **第三方许可证**
- OpenClaw: MIT许可证
- Node.js: MIT许可证
- Python: PSF许可证
- 飞书SDK: Apache 2.0

## 🙏 **致谢**

### **核心团队**
- **OpenClaw开发团队** - 创建了出色的AI框架
- **飞书平台团队** - 提供了优秀的消息基础设施
- **Linux社区** - 提供了强大的开源基础

### **贡献者**
感谢所有帮助改进此安装向导的贡献者！

### **特别感谢**
- 早期采用者和测试者
- 社区版主
- 文档贡献者
- 翻译志愿者

## 📈 **版本历史**

### **v1.0.0（当前）**
- 初始发布
- 多发行版支持
- 完全自动化
- 飞书集成
- 安全加固

### **计划功能**
- GUI安装向导
- Docker容器支持
- Kubernetes部署
- 高级监控
- 多语言支持

---

## 🎉 **立即开始！**

```bash
# 开始您的OpenClaw之旅
curl -fsSL https://raw.githubusercontent.com/Johnson811222/OpenClaw-Linux-Wizard/main/install.sh | sudo bash
```

### **需要帮助？**
- 加入我们的 [Discord社区](https://discord.gg/clawd)
- 查看 [文档](https://docs.openclaw.ai)
- 提交 [问题](https://github.com/Johnson811222/OpenClaw-Linux-Wizard/issues)

### **分享喜爱**
如果您觉得此向导有帮助，请：
- ⭐ 为仓库加星
- 🐛 报告问题
- 💬 与朋友分享
- 🔄 贡献改进

---

**愉快部署！您的AI助手只需一个命令！** 🚀

*最后更新: $(date)*
*维护者: OpenClaw团队*
