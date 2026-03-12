# 🐧 OpenClaw Linux 极速安装指南

<div align="center">

![OpenClaw Logo](https://img.shields.io/badge/OpenClaw-AI%20Assistant-blue)
![Linux](https://img.shields.io/badge/Linux-Ubuntu%2022.04-orange)
![License](https://img.shields.io/badge/License-MIT-green)
![Stars](https://img.shields.io/github/stars/Johnson811222/OpenClaw-Linux-Wizard?style=social)

**快速在Ubuntu/Linux上部署完整的OpenClaw AI助手生态系统**

[📖 文档](#-快速开始) | [⚡ 功能特性](#-功能特性) | [🛠️ 安装步骤](#️-安装步骤) | [📱 飞书集成](#-飞书集成) | [🌟 Star历史](#-star历史)

</div>

## ✨ 项目亮点

<div align="center">

| 特性 | 描述 | 状态 |
|------|------|------|
| ⚡ **10分钟部署** | 极速安装体验 | ✅ |
| 🎯 **一键脚本** | 自动化安装配置 | ✅ |
| 🔌 **飞书深度集成** | 企业级消息协作 | ✅ |
| 🛠️ **18个核心技能** | 完整功能生态 | ✅ |
| ⏰ **cron定时任务** | 系统级自动化 | ✅ |
| 🔒 **安全加固** | 权限控制最佳实践 | ✅ |

</div>

## 📊 安装统计

```bash
# 验证安装结果
✅ Node.js v18+      ✅ OpenClaw CLI
✅ 飞书连接正常      ✅ 18个核心技能  
✅ cron任务就绪      ✅ 文件操作权限
✅ 服务自启动        ✅ 系统监控
```

## 🚀 快速开始

### 1. 系统要求
- **Ubuntu 22.04 LTS** 或更高版本
- **2GB+ 内存**（推荐4GB）
- **10GB+ 磁盘空间**
- **稳定的网络连接**

### 2. 一键安装（推荐）
```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/yourusername/OpenClaw-Linux-Guide/main/install.sh

# 给执行权限
chmod +x install.sh

# 运行安装脚本
./install.sh
```

### 3. 分步安装
```bash
# 1. 安装Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 2. 安装OpenClaw
npm install -g openclaw

# 3. 初始化配置
openclaw init
```

## ⚡ 功能特性

### 🎭 AI助手核心
- **智能对话**：自然语言交互
- **文件操作**：创建、编辑、整理文件
- **网页搜索**：实时信息查询
- **天气查询**：全球天气信息

### 🔌 飞书集成
- **即时消息**：发送/接收消息
- **文档管理**：飞书文档操作
- **云盘同步**：文件上传下载
- **知识库**：Wiki内容管理

### 🛠️ 核心技能
```bash
# 已包含的18个核心技能
✅ feishu-doc     # 飞书文档
✅ file-manager   # 文件管理  
✅ brave-search   # 网页搜索
✅ weather        # 天气查询
✅ github         # GitHub集成
✅ auto-updater   # 自动更新
# ... 更多技能
```

### ⏰ 自动化任务
- **早晨问候**：每天7:00自动发送
- **工作空间整理**：每周自动整理
- **技能更新**：定期检查更新
- **系统维护**：日志清理、备份

## 🛠️ 安装步骤

### 第1步：环境准备
```bash
# 更新系统
sudo apt update
sudo apt upgrade -y

# 安装基础工具
sudo apt install -y curl wget git build-essential
```

### 第2步：OpenClaw安装
```bash
# 全局安装OpenClaw
npm install -g openclaw

# 验证安装
openclaw --version
```

### 第3步：飞书配置
1. 访问[飞书开放平台](https://open.feishu.cn/)
2. 创建企业自建应用
3. 获取应用凭证（App ID/Secret）
4. 配置环境变量

### 第4步：技能安装
```bash
# 一键安装所有技能
./install-skills.sh

# 或选择安装
clawhub install feishu-doc
clawhub install file-manager
```

### 第5步：验证安装
```bash
# 运行验证脚本
./verify-installation.sh

# 测试飞书连接
openclaw feishu test

# 发送测试消息
openclaw feishu send --message "Hello, OpenClaw!"
```

## 📱 飞书集成

### 应用配置
```bash
# 设置环境变量
export FEISHU_APP_ID="your_app_id"
export FEISHU_APP_SECRET="your_app_secret"
export FEISHU_VERIFICATION_TOKEN="your_token"

# 永久设置
echo 'export FEISHU_APP_ID="your_app_id"' >> ~/.bashrc
echo 'export FEISHU_APP_SECRET="your_app_secret"' >> ~/.bashrc
source ~/.bashrc
```

### 权限设置
- `im:message` - 发送/接收消息
- `drive:drive:readonly` - 读取云文档
- `wiki:wiki:readonly` - 读取知识库

### 消息示例
```bash
# 发送文本消息
openclaw feishu send --user "ou_xxx" --message "你好！"

# 发送富文本消息
openclaw feishu send --user "ou_xxx" --message "**重要通知**\n请查看文档"

# 定时发送（使用cron）
# 0 7 * * * cd /path && ./morning-greeting-template.sh
```

## 📁 项目结构

```
OpenClaw-Linux-Guide/
├── 📄 README.md                    # 项目说明
├── ⚡ install.sh                   # 一键安装脚本
├── 🛠️ install-skills.sh           # 技能安装脚本
├── 🌅 morning-greeting-template.sh # 早晨问候模板
├── ✅ verify-installation.sh      # 安装验证脚本
├── 📁 workspace-organizer.sh      # 工作空间整理
├── ⚙️ openclaw-config-template.json # 配置模板
├── 🐛 troubleshooting-checklist.md # 故障排除
├── 📋 quick-reference.md          # 快速参考
├── 📊 CHANGELOG.md                # 更新日志
└── 📄 LICENSE                     # 许可证
```

## 🐛 故障排除

### 常见问题
```bash
# 1. OpenClaw命令找不到
export PATH=$HOME/.npm-global/bin:$PATH
echo 'export PATH=$HOME/.npm-global/bin:$PATH' >> ~/.bashrc

# 2. 飞书连接失败
# 检查环境变量是否正确设置

# 3. 权限被拒绝
sudo chmod -R 755 ~/.openclaw

# 4. 端口被占用
# 修改配置文件中的端口号
```

### 错误代码参考
- **ECONNREFUSED**: 连接被拒绝，检查Gateway服务
- **EACCES**: 权限被拒绝，检查文件权限
- **ENOENT**: 文件不存在，检查路径
- **ETIMEDOUT**: 连接超时，检查网络

## 🤝 贡献指南

### 报告问题
1. 查看[故障排除](#-故障排除)
2. 搜索[现有Issue](https://github.com/Johnson811222/OpenClaw-Linux-Wizard/issues)
3. 创建新Issue，提供详细错误信息

### 提交改进
1. Fork项目仓库
2. 创建功能分支
3. 提交更改并测试
4. 创建Pull Request

### 开发规范
- 使用Bash编写脚本
- 添加详细的注释说明
- 包含错误处理逻辑
- 更新相关文档

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源。

## 🙏 致谢

感谢以下项目和社区：
- [OpenClaw](https://github.com/openclaw/openclaw) - 优秀的AI助手平台
- [飞书开放平台](https://open.feishu.cn/) - 强大的企业级API
- 所有贡献者和用户

## 🌟 Star历史

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/OpenClaw-Linux-Guide&type=Date)](https://star-history.com/#yourusername/OpenClaw-Linux-Guide&Date)

## 📞 联系

- **GitHub Issues**: [报告问题](https://github.com/Johnson811222/OpenClaw-Linux-Wizard/issues)
- **Discord社区**: [加入讨论](https://discord.com/invite/clawd)
- **官方文档**: [查看文档](https://docs.openclaw.ai)

---

<div align="center">

**如果这个项目对你有帮助，请给个⭐️ Star支持！**

[⬆️ 返回顶部](#-openclaw-linux-极速安装指南)

</div>