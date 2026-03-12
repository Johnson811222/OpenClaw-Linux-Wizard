# OpenClaw Linux 快速参考指南

## 🚀 快速开始

### 1. 系统要求检查
```bash
# 检查系统版本
lsb_release -a

# 检查Node.js
node --version  # 需要 v18+
npm --version   # 需要 9+

# 检查内存和磁盘
free -h
df -h
```

### 2. 一键安装脚本
```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/openclaw/openclaw/main/install.sh

# 运行安装脚本
chmod +x install.sh
./install.sh
```

### 3. 基础配置
```bash
# 初始化工作空间
openclaw init

# 启动服务
openclaw gateway start

# 检查状态
openclaw gateway status
```

## 📱 飞书集成

### 环境变量配置
```bash
# 临时设置
export FEISHU_APP_ID="your_app_id"
export FEISHU_APP_SECRET="your_app_secret"
export FEISHU_VERIFICATION_TOKEN="your_verification_token"

# 永久设置
echo 'export FEISHU_APP_ID="your_app_id"' >> ~/.bashrc
echo 'export FEISHU_APP_SECRET="your_app_secret"' >> ~/.bashrc
source ~/.bashrc
```

### 飞书命令速查
```bash
# 测试连接
openclaw feishu test

# 发送消息
openclaw feishu send --user "ou_xxx" --message "你好！"

# 查看权限
openclaw feishu scopes

# 获取用户信息
openclaw feishu user --id "ou_xxx"
```

## 🛠️ 技能管理

### ClawHub 命令
```bash
# 安装技能
clawhub install feishu-doc
clawhub install file-manager

# 列出技能
clawhub list

# 搜索技能
clawhub search weather

# 更新技能
clawhub update

# 查看技能信息
clawhub info feishu-doc
```

### 核心技能列表
```bash
# 飞书相关
feishu-doc      # 文档操作
feishu-drive    # 云盘管理
feishu-wiki     # 知识库
feishu-perm     # 权限管理

# 开发工具
github          # GitHub集成
gog             # Google Workspace

# 系统管理
healthcheck     # 安全检查
openai-whisper  # 语音转文字
skill-creator   # 技能创建
summarize       # 内容摘要
tmux            # 终端管理

# 信息服务
weather         # 天气查询
brave-search    # 网页搜索
news-summary    # 新闻摘要

# AI和自我改进
self-improving  # 自我改进代理
agent-browser   # 浏览器自动化

# 自动化
auto-updater    # 自动更新
file-manager    # 文件管理
find-skills     # 技能发现
```

### 运行技能
```bash
# 基本格式
openclaw skill run <skill-name> --action <action> [options]

# 示例
openclaw skill run file-manager --action organize
openclaw skill run weather --location "上海"
openclaw skill run brave-search --query "OpenClaw"
```

## 📁 文件操作

### 工作空间结构
```
~/.openclaw/workspace/
├── 01-projects/     # 项目目录
├── 02-tools/        # 工具脚本
├── 03-docs/         # 文档资料
├── 04-memory/       # 记忆系统
├── 05-configs/      # 配置文件
├── 06-backups/      # 备份文件
├── 07-temp/         # 临时文件
└── 08-archive/      # 历史归档
```

### 文件管理命令
```bash
# 整理工作空间
openclaw skill run file-manager --action organize

# 清理重复文件
openclaw skill run file-manager --action clean-duplicates

# 批量重命名
openclaw skill run file-manager --action rename --pattern "*.txt"

# 文件搜索
openclaw skill run file-manager --action search --query "keyword"
```

## ⏰ 定时任务

### Cron 配置
```bash
# 查看当前cron任务
crontab -l

# 编辑cron任务
crontab -e

# 删除所有cron任务
crontab -r
```

### 常用定时任务
```bash
# 每天7:00发送早晨问候
0 7 * * * cd /path/to/scripts && ./morning-greeting.sh

# 每周日2:00整理工作空间
0 2 * * 0 cd /path/to/scripts && ./workspace-organizer.sh

# 每天3:00检查技能更新
0 3 * * * clawhub update --dry-run

# 每小时检查系统状态
0 * * * * openclaw gateway status
```

### 早晨问候脚本配置
```bash
# 编辑配置
vim morning-greeting.sh

# 修改用户ID
USER_ID="ou_8156ee1158132a9df669373a9fd60275"

# 启用天气
ENABLE_WEATHER=true
LOCATION="上海"

# 添加执行权限
chmod +x morning-greeting.sh

# 测试运行
./morning-greeting.sh
```

## 🔧 系统管理

### 服务管理
```bash
# 启动服务
openclaw gateway start

# 停止服务
openclaw gateway stop

# 重启服务
openclaw gateway restart

# 查看状态
openclaw gateway status

# 查看日志
openclaw gateway logs
openclaw gateway logs --follow  # 实时查看
openclaw gateway logs --tail 50 # 最后50行
```

### 配置管理
```bash
# 配置文件位置
~/.openclaw/config.json

# 查看配置
cat ~/.openclaw/config.json | jq .  # 需要安装jq

# 备份配置
cp ~/.openclaw/config.json ~/.openclaw/config.json.backup

# 恢复配置
cp ~/.openclaw/config.json.backup ~/.openclaw/config.json
```

### 性能优化
```bash
# 增加Node.js内存限制
export NODE_OPTIONS="--max-old-space-size=4096"

# 启用调试模式
export DEBUG="openclaw:*"

# 清理缓存
npm cache clean --force
rm -rf ~/.openclaw/cache

# 查看内存使用
ps aux | grep node
top -p $(pgrep -f openclaw)
```

## 🐛 故障排除

### 快速诊断
```bash
# 运行验证脚本
./verify-installation.sh

# 检查网络连接
curl -I https://open.feishu.cn

# 检查端口占用
sudo netstat -tlnp | grep :3000

# 查看错误日志
tail -f ~/.openclaw/logs/error.log
```

### 常见问题解决
```bash
# 1. OpenClaw命令找不到
echo 'export PATH=$HOME/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 2. 权限被拒绝
chmod -R 755 ~/.openclaw

# 3. 端口被占用
# 修改 ~/.openclaw/config.json 中的端口号

# 4. 飞书连接失败
# 检查环境变量是否正确设置
```

### 重置系统
```bash
# 备份重要数据
tar -czf openclaw-backup-$(date +%Y%m%d).tar.gz ~/.openclaw

# 完全卸载
npm uninstall -g openclaw
rm -rf ~/.openclaw

# 重新安装
npm install -g openclaw
openclaw init
```

## 📊 监控和维护

### 日常检查
```bash
# 检查服务状态
openclaw gateway status

# 检查飞书连接
openclaw feishu test

# 检查技能更新
clawhub update --dry-run

# 检查磁盘空间
df -h ~/.openclaw

# 检查日志大小
du -sh ~/.openclaw/logs/
```

### 定期维护
```bash
# 每周清理日志
find ~/.openclaw/logs -name "*.log" -mtime +7 -delete

# 每月备份配置
cp ~/.openclaw/config.json ~/.openclaw/backups/config-$(date +%Y-%m).json

# 每季度整理工作空间
./workspace-organizer.sh
```

### 性能监控
```bash
# 监控Gateway进程
watch -n 5 'ps aux | grep openclaw'

# 监控内存使用
watch -n 5 'free -h'

# 监控网络连接
sudo netstat -tlnp | grep node
```

## 🔌 高级功能

### 自定义技能开发
```bash
# 创建新技能
openclaw skill create my-skill

# 技能目录结构
my-skill/
├── SKILL.md      # 技能文档
├── package.json  # 依赖配置
├── index.js      # 主程序
└── test/         # 测试文件

# 测试技能
openclaw skill test my-skill

# 发布技能
clawhub publish my-skill
```

### API 集成
```bash
# 使用curl测试API
curl -X POST http://localhost:3000/api/message \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, OpenClaw!"}'

# 获取会话历史
curl http://localhost:3000/api/sessions

# 执行工具调用
curl -X POST http://localhost:3000/api/tools/exec \
  -H "Content-Type: application/json" \
  -d '{"command": "ls -la"}'
```

### 多环境配置
```bash
# 开发环境配置
cp ~/.openclaw/config.json ~/.openclaw/config.dev.json

# 生产环境配置
cp ~/.openclaw/config.json ~/.openclaw/config.prod.json

# 切换环境
ln -sf ~/.openclaw/config.dev.json ~/.openclaw/config.json
openclaw gateway restart
```

## 🎯 最佳实践

### 1. 安全实践
- 使用非root用户运行OpenClaw
- 定期更新OpenClaw和技能
- 备份配置文件和重要数据
- 监控日志中的异常活动

### 2. 性能优化
- 为Node.js分配足够内存
- 定期清理日志和缓存
- 使用cron进行定期维护
- 监控系统资源使用

### 3. 开发实践
- 使用版本控制管理配置
- 为自定义技能编写测试
- 文档化所有配置变更
- 定期审查和优化工作流

### 4. 运维实践
- 建立定期备份策略
- 设置监控和告警
- 文档化故障排除步骤
- 定期进行系统审计

## 📞 获取帮助

### 官方资源
```bash
# 查看文档
openclaw docs

# 查看版本信息
openclaw --version

# 查看帮助
openclaw help
openclaw feishu --help
openclaw skill --help
```

### 社区支持
- **GitHub Issues**: https://github.com/openclaw/openclaw/issues
- **Discord社区**: https://discord.com/invite/clawd
- **官方文档**: https://docs.openclaw.ai

### 调试信息收集
当寻求帮助时，请提供：
```bash
# 系统信息
lsb_release -a
uname -a

# OpenClaw信息
openclaw --version
openclaw gateway status

# 配置文件（脱敏后）
grep -v "appSecret\|encryptKey" ~/.openclaw/config.json

# 错误日志
tail -100 ~/.openclaw/logs/error.log
```

---

## 🎉 使用愉快！

希望这份快速参考指南能帮助你更好地使用OpenClaw。如果有任何问题或建议，请随时联系。

**开心豆 😊**  
*你的专属AI助手*  
*最后更新：2026年3月12日*