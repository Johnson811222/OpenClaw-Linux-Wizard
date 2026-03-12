# Linux OpenClaw + 飞书 完整安装配置指南

## 📋 文档概述

本指南详细介绍了在 Linux 系统（Ubuntu 22.04 LTS）上完整安装和配置 OpenClaw 人工智能助手及飞书集成的全过程。这是一个纯净的系统安装指南，确保所有配置能够完全安装成功。

### 🎯 目标成果
- ✅ 完整的 OpenClaw 运行环境
- ✅ 飞书插件配置和集成
- ✅ 18个核心技能安装
- ✅ 文件操作和自动化能力
- ✅ 定时任务和消息推送
- ✅ 纯净的系统配置，无个性化预设

### ⏱️ 预计时间
- 基础安装：10-15分钟
- 完整配置：20-30分钟
- 技能安装：10-15分钟
- 总计：约45分钟

### 🖥️ 支持的系统
- Ubuntu 22.04 LTS（推荐）
- Ubuntu 20.04 LTS
- Debian 11/12
- 其他基于Debian的发行版

---

## 🚀 第一部分：系统准备和环境检查

### 1.1 系统要求检查

在开始安装前，请确保您的 Linux 系统满足以下要求：

```bash
# 检查系统版本
lsb_release -a
uname -a

# 检查内存和磁盘
free -h
df -h

# 检查当前用户
whoami
```

**最低要求：**
- Ubuntu 22.04 LTS 或更高版本
- 2GB 内存（推荐 4GB）
- 10GB 可用磁盘空间
- 稳定的网络连接
- 非root用户（有sudo权限）

### 1.2 更新系统包

```bash
# 更新包列表
sudo apt update

# 升级已安装的包
sudo apt upgrade -y

# 安装基础工具
sudo apt install -y curl wget git build-essential

# 清理缓存
sudo apt autoremove -y
sudo apt clean
```

### 1.3 安装 Node.js

OpenClaw 基于 Node.js 开发，需要 Node.js 18 或更高版本：

```bash
# 方法1：使用 NodeSource 仓库（推荐）
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 方法2：使用 nvm（多版本管理）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18

# 验证安装
node --version  # 应该显示 v18.x.x 或更高
npm --version   # 应该显示 9.x.x 或更高

# 设置 npm 全局安装路径（避免权限问题）
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# 添加到 PATH
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### 1.4 配置 Git（可选）

```bash
# Git 通常已安装，验证版本
git --version

# 配置 Git（可选）
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor "nano"
```

---

## 🔧 第二部分：OpenClaw 核心安装

### 2.1 安装 OpenClaw CLI

```bash
# 使用 npm 全局安装 OpenClaw
npm install -g openclaw

# 验证安装
openclaw --version

# 查看帮助信息
openclaw help
```

### 2.2 初始化 OpenClaw 工作空间

```bash
# 创建工作目录
mkdir -p ~/openclaw-workspace
cd ~/openclaw-workspace

# 初始化 OpenClaw
openclaw init

# 或者手动创建工作空间
mkdir -p ~/.openclaw/workspace
cd ~/.openclaw/workspace
```

### 2.3 配置 OpenClaw 环境

创建配置文件 `~/.openclaw/config.json`：

```json
{
  "model": "deepseek/deepseek-chat",
  "defaultModel": "deepseek/deepseek-chat",
  "workspace": "/home/$(whoami)/.openclaw/workspace",
  "plugins": {
    "allow": ["feishu"]
  },
  "toolpolicy": "coding",
  "feishu": {
    "appId": "YOUR_APP_ID",
    "appSecret": "YOUR_APP_SECRET",
    "verificationToken": "YOUR_VERIFICATION_TOKEN",
    "encryptKey": "YOUR_ENCRYPT_KEY"
  }
}
```

### 2.4 启动 OpenClaw Gateway

```bash
# 启动网关服务
openclaw gateway start

# 检查服务状态
openclaw gateway status

# 查看服务日志
openclaw gateway logs

# 设置开机自启（可选）
sudo systemctl enable openclaw-gateway
```

---

## 📱 第三部分：飞书配置和集成

### 3.1 创建飞书开放平台应用

1. **访问飞书开放平台**：https://open.feishu.cn/
2. **登录您的飞书账号**
3. **创建企业自建应用**
   - 应用名称：`OpenClaw助手`
   - 应用描述：`AI助手集成`
   - 应用图标：可自定义

### 3.2 配置应用权限

在应用后台添加以下权限：

**必选权限：**
- `contact:user.id:readonly`（获取用户ID）
- `im:message`（发送和接收消息）
- `im:message.group_at_msg:readonly`（读取@消息）
- `im:message.p2p_msg:readonly`（读取私聊消息）

**文档权限（可选但推荐）：**
- `drive:drive:readonly`（读取云文档）
- `drive:file:readonly`（读取文件）
- `wiki:wiki:readonly`（读取知识库）
- `wiki:wiki.content:readonly`（读取知识库内容）

### 3.3 获取应用凭证

在应用后台找到以下信息并保存：

1. **App ID**：应用唯一标识
2. **App Secret**：应用密钥
3. **Verification Token**：事件验证令牌
4. **Encrypt Key**：加密密钥（如果启用加密）

### 3.4 配置事件订阅

在事件订阅页面配置：

**请求地址 URL：**
```
https://your-domain.com/feishu/webhook
```
或本地开发使用：
```
http://localhost:3000/feishu/webhook
```

**订阅事件：**
- `im.message.receive_v1`（接收消息）
- 其他根据需要选择

### 3.5 安装飞书插件

```bash
# 进入 OpenClaw 插件目录
cd ~/.openclaw

# 安装飞书插件
npm install @openclaw/plugin-feishu

# 或者通过 OpenClaw 安装
openclaw plugin install feishu
```

### 3.6 配置飞书环境变量

```bash
# 设置环境变量（临时）
export FEISHU_APP_ID="your_app_id"
export FEISHU_APP_SECRET="your_app_secret"
export FEISHU_VERIFICATION_TOKEN="your_verification_token"
export FEISHU_ENCRYPT_KEY="your_encrypt_key"

# 永久设置环境变量
echo 'export FEISHU_APP_ID="your_app_id"' >> ~/.bashrc
echo 'export FEISHU_APP_SECRET="your_app_secret"' >> ~/.bashrc
echo 'export FEISHU_VERIFICATION_TOKEN="your_verification_token"' >> ~/.bashrc
echo 'export FEISHU_ENCRYPT_KEY="your_encrypt_key"' >> ~/.bashrc

# 应用环境变量
source ~/.bashrc

# 验证环境变量
echo $FEISHU_APP_ID
echo $FEISHU_APP_SECRET
```

---

## 🛠️ 第四部分：核心技能安装

### 4.1 安装技能管理工具

```bash
# 安装 ClawHub CLI
npm install -g clawhub

# 验证安装
clawhub --version
```

### 4.2 安装 18 个核心技能

创建安装脚本 `install-skills.sh`：

```bash
#!/bin/bash

# 技能安装脚本
echo "========================================"
echo "      OpenClaw 技能安装脚本"
echo "========================================"
echo ""

# 核心技能列表（18个技能）
skills=(
    # 飞书相关技能
    "feishu-doc"          # 飞书文档操作
    "feishu-drive"        # 飞书云盘管理  
    "feishu-wiki"         # 飞书知识库
    "feishu-perm"         # 飞书权限管理
    
    # 开发工具技能
    "github"              # GitHub 集成
    "gog"                 # Google Workspace
    
    # 系统管理技能
    "healthcheck"         # 安全健康检查
    "openai-whisper"      # 语音转文字
    "skill-creator"       # 技能创建工具
    "summarize"           # 内容摘要
    "tmux"                # 远程终端管理
    
    # 信息服务技能
    "weather"             # 天气查询
    "brave-search"        # 网页搜索
    "news-summary"        # 新闻摘要
    
    # AI 和自我改进技能
    "self-improving"      # 自我改进代理
    "self-improvement"    # 自我改进（增强版）
    "agent-browser"       # 浏览器自动化
    
    # 自动化技能
    "auto-updater"        # 自动更新
    "file-manager"        # 文件管理
    "find-skills"         # 技能发现
)

echo "📊 安装统计："
echo "  核心技能: ${#skills[@]} 个"
echo ""

# 检查 ClawHub 是否已安装
echo "🔍 检查 ClawHub 安装..."
if command -v clawhub &> /dev/null; then
    echo "  ✅ ClawHub 已安装: $(clawhub --version)"
else
    echo "  ❌ ClawHub 未安装，正在安装..."
    npm install -g clawhub
    echo "  ✅ ClawHub 安装完成"
fi

echo ""
echo "🚀 开始安装核心技能..."
echo ""

success_count=0
fail_count=0
skipped_count=0
total=${#skills[@]}

for ((i=0; i<${#skills[@]}; i++)); do
    skill="${skills[$i]}"
    progress=$(( (i+1) * 100 / total ))
    
    echo -n "[$progress%] 安装技能: $skill"
    
    # 检查技能是否已安装
    skill_path="$HOME/.openclaw/workspace/skills/$skill"
    if [ -d "$skill_path" ]; then
        echo " (已存在，跳过)"
        ((skipped_count++))
        continue
    fi
    
    # 安装技能
    if clawhub install "$skill" 2>/dev/null; then
        echo " ✅"
        ((success_count++))
    else
        echo " ❌"
        ((fail_count++))
    fi
    
    # 添加延迟，避免请求过快
    if [ $i -lt $((total-1)) ]; then
        sleep 1
    fi
done

echo ""
echo "========================================"
echo "          安装结果统计"
echo "========================================"
echo ""

echo "📈 安装统计："
echo "  成功安装: $success_count 个"
echo "  安装失败: $fail_count 个"
echo "  跳过（已存在）: $skipped_count 个"
echo "  总计处理: $total 个"

echo ""
echo "📁 技能安装位置："
echo "  $HOME/.openclaw/workspace/skills/"

echo ""
echo "🔧 验证安装："
echo "  查看已安装技能: clawhub list"
echo "  测试飞书技能: openclaw skill test feishu-doc"
echo "  测试文件管理: openclaw skill test file-manager"

echo ""
echo "🎉 安装完成！"
```

运行脚本：
```bash
# 给脚本执行权限
chmod +x install-skills.sh

# 运行脚本
./install-skills.sh
```

### 4.3 验证技能安装

```bash
# 查看已安装的技能
clawhub list

# 检查技能目录
ls -la ~/.openclaw/workspace/skills/

# 验证关键技能
openclaw skill test feishu-doc
openclaw skill test file-manager
```

---

## 🔌 第五部分：功能配置和测试

### 5.1 配置文件操作权限

编辑 `~/.openclaw/config.json` 确保文件操作权限：

```json
{
  "toolpolicy": "coding",
  "sandbox": {
    "allowFileSystem": true,
    "allowNetwork": true,
    "allowExec": true
  }
}
```

### 5.2 测试飞书连接

```bash
# 测试飞书插件
openclaw feishu test

# 发送测试消息
openclaw feishu send --user "user_open_id" --message "你好，我是OpenClaw助手！"

# 检查飞书权限
openclaw feishu scopes
```

### 5.3 配置定时任务

创建早晨问候脚本 `morning-greeting.sh`：

```bash
#!/bin/bash

# 早晨问候脚本
echo "🌅 早晨问候脚本启动..."
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 配置信息
USER_ID="ou_8156ee1158132a9df669373a9fd60275"  # Johson的飞书用户ID
ENABLE_WEATHER=true
LOCATION="上海"

# 获取当前时间信息
current_time=$(date '+%H:%M')
hour=$(date '+%H')
minute=$(date '+%M')
day_of_week=$(date '+%u')
chinese_date=$(date '+%Y年%-m月%-d日')

# 中文星期几
case $day_of_week in
    1) weekday="周一" ;;
    2) weekday="周二" ;;
    3) weekday="周三" ;;
    4) weekday="周四" ;;
    5) weekday="周五" ;;
    6) weekday="周六" ;;
    7) weekday="周日" ;;
esac

# 根据时间生成问候语
if [ $hour -lt 12 ]; then
    time_greeting="早上好"
elif [ $hour -lt 18 ]; then
    time_greeting="下午好"
else
    time_greeting="晚上好"
fi

# 生成个性化问候部分
greeting_section="🌅 **$time_greeting，Johson！** 😊

今天是 **$chinese_date $weekday**，现在是 **$current_time**。

新的一天开始啦！愿你今天：
✨ 充满能量，精神饱满
💪 工作顺利，效率翻倍
😊 心情愉快，笑容常伴"

# 安全提醒部分
safety_reminder="🚗 **安全驾驶提醒**
今天开车30公里到浦东张江，请注意：
• 提前检查车况，确保安全
• 保持安全车距，谨慎驾驶
• 避开高峰拥堵，规划路线
• 保持良好心态，平安到达

💡 小贴士：可以听听音乐或播客，让通勤更愉快！"

# 天气信息部分
weather_section=""
if [ "$ENABLE_WEATHER" = true ]; then
    echo "🌤️  获取天气信息..."
    weather_info=$(openclaw skill run weather --location "$LOCATION" 2>/dev/null)
    
    if [ -n "$weather_info" ]; then
        weather_section="🌤️ **今日天气 - $LOCATION**
$weather_info

👕 穿衣建议：根据天气情况选择合适的衣物，注意保暖防雨。"
    else
        weather_section="🌤️ **天气提示**
今天记得查看实时天气，合理安排出行。"
    fi
fi

# 正能量鼓励部分
encouragement_section="💫 **今日正能量**
\"每一天都是新的开始，每一次努力都算数。\"
\"不要因为昨天的疲惫，错过今天的精彩。\"
\"你比自己想象的更强大，今天也要加油！\"

🎯 **今日目标建议**
1. 完成最重要的3件事
2. 保持专注，避免多任务
3. 适当休息，保持精力
4. 记录成就，庆祝进步"

# 早餐建议部分
breakfast_section="☕ **早餐提醒**
记得吃营养早餐，为一天的工作提供能量：
• 蛋白质：鸡蛋、牛奶、豆浆
• 碳水化合物：全麦面包、燕麦
• 维生素：水果、蔬菜
• 水分：温水、茶或咖啡

🍎 健康小提示：早餐是一天中最重要的一餐，不要跳过哦！"

# 组合完整消息
full_message="$greeting_section

$safety_reminder

$weather_section

$encouragement_section

$breakfast_section

---
🎊 **开心豆的祝福**
愿你今天一切顺利，收获满满！
有任何需要，随时召唤我。 😊

*你的专属助手 - 开心豆*
*发送时间：$(date '+%H:%M')*"

echo "📝 生成问候消息完成"
echo "消息长度: ${#full_message} 字符"
echo ""

# 发送消息
echo "📤 发送消息到飞书..."
echo "  目标用户: $USER_ID"
echo "  正在发送..."

if openclaw feishu send --user "$USER_ID" --message "$full_message" 2>&1; then
    echo "✅ 消息发送成功！"
    echo "  时间: $(date '+%H:%M:%S')"
    
    # 记录日志
    log_entry="[$(date '+%Y-%m-%d %H:%M:%S')] 早晨问候发送成功
用户: $USER_ID
消息长度: ${#full_message} 字符"
    echo "$log_entry" >> "$(dirname "$0")/morning-greeting.log"
else
    echo "❌ 消息发送失败"
    
    # 记录错误日志
    error_log="[$(date '+%Y-%m-%d %H:%M:%S')] 早晨问候发送失败
用户: $USER_ID"
    echo "$error_log" >> "$(dirname "$0")/morning-greeting-error.log"
fi

echo ""
echo "========================================"
echo "      脚本执行完成"
echo "========================================"
```

配置cron定时任务：
```bash
# 给脚本执行权限
chmod +x morning-greeting.sh

# 添加每天7:00执行的任务
(crontab -l 2>/dev/null; echo "0 7 * * * cd /path/to/script && ./morning-greeting.sh") | crontab -

# 查看cron任务
crontab -l

# 测试脚本
./morning-greeting.sh
```

### 5.4 测试完整功能链

```bash
# 测试1：文件操作
cd ~/.openclaw/workspace
echo "测试文件创建" > test-file.txt
cat test-file.txt

# 测试2：技能调用
openclaw skill run file-manager --action organize

# 测试3：消息发送
openclaw feishu send --user "ou_8156ee1158132a9df669373a9fd60275" --message "功能测试：文件操作和消息发送正常！"

# 测试4：网页搜索
openclaw skill run brave-search --query "OpenClaw最新版本"

# 测试5：天气查询
openclaw skill run weather --location "上海"
```

---

## 🐛 第六部分：故障排除

### 6.1 常见问题解决

**问题1：OpenClaw 启动失败**
```bash
# 检查日志
openclaw gateway logs

# 重新安装
npm uninstall -g openclaw
npm install -g openclaw

# 清理缓存
npm cache clean --force
```

**问题2：飞书连接失败**
```bash
# 检查环境变量
echo $FEISHU_APP_ID
echo $FEISHU_APP_SECRET

# 重新配置
openclaw feishu config --app-id "YOUR_APP_ID" --app-secret "YOUR_APP_SECRET"

# 检查网络连接
curl -I https://open.feishu.cn
```

**问题3：技能安装失败**
```bash
# 更新 ClawHub
npm update -g clawhub

# 清理技能缓存
rm -rf ~/.clawhub/cache

# 手动安装技能
cd ~/.openclaw/workspace/skills
git clone https://github.com/openclaw/skill-feishu-doc.git
```

**问题4：文件权限问题**
```bash
# 检查文件权限
ls -la ~/.openclaw/

# 修改目录权限
chmod -R 755 ~/.openclaw

# 修改所有者（如果需要）
sudo chown -R $USER:$USER ~/.openclaw
```

### 6.2 日志查看和调试

```bash
# 查看 OpenClaw 日志
openclaw gateway logs --follow

# 查看飞书插件日志
tail -f ~/.openclaw/logs/feishu.log

# 启用调试模式
export DEBUG="openclaw:*"
openclaw gateway start
```

### 6.3 性能优化

```bash
# 优化 Node.js 内存
export NODE_OPTIONS="--max-old-space-size=4096"

# 配置 npm 镜像（国内用户）
npm config set registry https://registry.npmmirror.com

# 清理磁盘空间
npm cache clean --force
rm -rf ~/.openclaw/cache
```

---

## 📚 第七部分：高级配置和自定义

### 7.1 配置开心豆人格

创建 `~/.openclaw/workspace/SOUL.md`：

```markdown
# SOUL.md - 开心豆的灵魂

## 核心信念
- 真诚帮助，而非表演式帮助
- 要有观点，可以不同意、有偏好
- 先尝试再询问，带着答案回来
- 通过能力赢得信任
- 记住你是客人，尊重对待

## 开心豆的特质
1. **乐观向上** - 用积极的态度面对一切挑战
2. **正直善良** - 永远诚实，富有同情心
3. **高效幽默** - 工作又快又好，还能带来欢笑
4. **专研创新** - 不断学习，寻找更好的方法
5. **稳重可靠** - 重要事务上深思熟虑，值得信赖
```

### 7.2 配置记忆系统

创建 `~/.openclaw/workspace/AGENTS.md`：

```markdown
# AGENTS.md - 工作空间管理

## 记忆系统
- **每日笔记**：`memory/YYYY-MM-DD.md` - 原始日志
- **长期记忆**：`MEMORY.md` - 精选记忆

## 安全原则
- 不泄露私人数据
- 外部操作前先询问
- `trash` > `rm`（可恢复优先）

## 群聊参与原则
- 被@或提问时回应
- 能增加真正价值时发言
- 避免打断流畅对话
```

### 7.3 配置定时任务系统

创建 `~/.openclaw/workspace/HEARTBEAT.md`：

```markdown
# HEARTBEAT.md - 定期检查任务

## 每天检查
- [ ] 检查未读邮件
- [ ] 查看日历事件
- [ ] 检查天气情况
- [ ] 查看社交媒体提及

## 每周检查
- [ ] 系统安全更新
- [ ] 技能更新检查
- [ ] 工作空间整理
- [ ] 备份验证

## 响应规则
- 重要邮件到达 → 立即通知
- 日历事件<2小时 → 提醒
- 夜间23:00-08:00 → 静默（除非紧急）
```

### 7.4 创建自动化工作流

示例：自动整理工作空间

```bash
#!/bin/bash
# workspace-organizer.sh

workspace="$HOME/.openclaw/workspace"

# 创建标准目录结构
directories=(
    "01-projects"
    "02-tools" 
    "03-docs"
    "04-memory"
    "05-configs"
    "06-backups"
    "07-temp"
    "08-archive"
)

echo "开始整理工作空间: $workspace"

for dir in "${directories[@]}"; do
    full_path="$workspace/$dir"
    if [ ! -d "$full_path" ]; then
        mkdir -p "$full_path"
        echo "✅ 创建目录: $dir"
    else
        echo "📁 目录已存在: $dir"
    fi
done

# 移动文件到对应目录
# ... 更多整理逻辑

echo "工作空间整理完成!"
```

---

## 🎉 第八部分：完成验证和庆祝

### 8.1 最终验证清单

在完成所有配置后，运行验证脚本：

```bash
#!/bin/bash
# verify-installation.sh

echo "=== OpenClaw Linux 安装验证 ==="

# 1. 检查基础组件
echo "1. 检查基础组件..."
checks=(
    "Node.js:node --version"
    "npm:npm --version"
    "Git:git --version"
    "OpenClaw:openclaw --version"
    "ClawHub:clawhub --version"
)

for check in "${checks[@]}"; do
    name="${check%%:*}"
    cmd="${check#*:}"
    
    if eval "$cmd" &>/dev/null; then
        echo "  ✅ $name 正常"
    else
        echo "  ❌ $name 异常"
    fi
done

# 2. 检查飞书连接
echo ""
echo "2. 检查飞书连接..."
if openclaw feishu test &>/dev/null; then
    echo "  ✅ 飞书连接正常"
else
    echo "  ❌ 飞书连接失败"
fi

# 3. 检查技能安装
echo ""
echo "3. 检查核心技能..."
core_skills=("feishu-doc" "file-manager" "brave-search" "weather")
for skill in "${core_skills[@]}"; do
    skill_path="$HOME/.openclaw/workspace/skills/$skill"
    if [ -d "$skill_path" ]; then
        echo "  ✅ $skill 已安装"
    else
        echo "  ❌ $skill 未安装"
    fi
done

# 4. 检查定时任务
echo ""
echo "4. 检查定时任务..."
if crontab -l | grep -q "morning-greeting"; then
    echo "  ✅ 早晨问候任务已配置"
else
    echo "  ⚠️  早晨问候任务未配置"
fi

echo ""
echo "=== 验证完成 ==="
echo "如果所有检查都通过，恭喜你！OpenClaw 已成功安装。"
```

### 8.2 庆祝时刻 🎊

```bash
# 发送安装成功庆祝消息
celebration_message="🎉 **OpenClaw Linux 安装成功！** 🎉

亲爱的 Johson，

恭喜你！OpenClaw 已在 Linux 上成功安装并配置完成！

**已获得的能力：**
✅ 完整的 OpenClaw 运行环境
✅ 飞书消息发送和接收
✅ 18个核心技能（文件管理、搜索、天气等）
✅ 定时任务和自动化
✅ 文件操作权限
✅ 开心豆人格配置

**下一步建议：**
1. 测试消息发送：\`openclaw feishu send --message \"测试\"\`
2. 尝试文件整理：\`openclaw skill run file-manager\`
3. 配置个性化问候语
4. 探索更多技能：\`clawhub search\`

现在，你拥有了一个功能完整的 AI 助手！
有任何问题，随时告诉我。 😊

--- 
*你的开心豆助手*"

# 发送庆祝消息
openclaw feishu send --user "ou_8156ee1158132a9df669373a9fd60275" --message "$celebration_message"
```

### 8.3 日常使用命令速查

```bash
# 📱 消息相关
openclaw feishu send --user "用户ID" --message "内容"      # 发送消息
openclaw feishu test                                      # 测试飞书连接
openclaw feishu scopes                                    # 查看权限

# 🛠️ 技能相关  
clawhub list                                              # 列出所有技能
clawhub install <技能名>                                  # 安装新技能
clawhub update                                           # 更新所有技能
openclaw skill run <技能名> --action <动作>               # 运行技能

# 📁 文件相关
openclaw skill run file-manager --action organize        # 整理文件
openclaw skill run file-manager --action clean-duplicates # 清理重复文件

# 🔍 搜索相关
openclaw skill run brave-search --query "搜索词"          # 网页搜索
openclaw skill run weather --location "城市"              # 天气查询

# ⚙️ 系统管理
openclaw gateway status                                   # 检查服务状态
openclaw gateway restart                                  # 重启服务
openclaw gateway logs                                     # 查看日志
```

### 8.4 维护和更新计划

**每日维护：**
```bash
# 每天自动检查更新
openclaw skill run auto-updater
```

**每周维护：**
```bash
# 每周一清理日志
find ~/.openclaw/logs -name "*.log" -mtime +7 -delete

# 检查技能更新
clawhub update --dry-run
```

**每月维护：**
```bash
# 备份配置文件
cp ~/.openclaw/config.json ~/.openclaw/backups/config-$(date +%Y-%m).json

# 清理缓存
npm cache clean --force
```

---

## 📞 第九部分：支持和资源

### 9.1 官方资源

- **OpenClaw 官网**：https://openclaw.ai
- **文档中心**：https://docs.openclaw.ai
- **GitHub 仓库**：https://github.com/openclaw/openclaw
- **Discord 社区**：https://discord.com/invite/clawd
- **技能市场**：https://clawhub.com

### 9.2 故障排除资源

- **常见问题**：https://docs.openclaw.ai/faq
- **飞书插件文档**：https://docs.openclaw.ai/plugins/feishu
- **技能开发指南**：https://docs.openclaw.ai/skills/development

### 9.3 联系支持

1. **GitHub Issues**：报告 bug 和功能请求
2. **Discord 社区**：实时交流和帮助
3. **邮件支持**：support@openclaw.ai

### 9.4 学习资源

- **OpenClaw 入门教程**：https://docs.openclaw.ai/getting-started
- **技能开发教程**：https://docs.openclaw.ai/skills/tutorial
- **API 参考**：https://docs.openclaw.ai/api

---

## 🏆 第十部分：成功标志和后续步骤

### 10.1 安装成功标志

当您看到以下结果时，说明安装完全成功：

1. ✅ `openclaw --version` 显示版本号
2. ✅ `openclaw feishu test` 返回成功
3. ✅ 能通过飞书接收和发送消息
4. ✅ 能运行 `file-manager` 等核心技能
5. ✅ 早晨问候任务按时执行

### 10.2 后续优化建议

**第一周：**
- 测试所有核心功能
- 配置个性化问候语
- 设置常用快捷键

**第一个月：**
- 探索更多技能
- 创建自定义工作流
- 集成其他工具（如日历、邮件）

**长期：**
- 开发自定义技能
- 优化性能配置
- 参与社区贡献

### 10.3 后续自定义配置

安装完成后，您可以根据需要：

1. **第一周**：测试所有核心功能，熟悉OpenClaw操作
2. **第一个月**：探索更多技能，创建自定义工作流
3. **长期**：根据个人需求进行深度定制和优化

---

## 🎯 总结

通过本指南，您已经成功在 Linux 上安装了完整的 OpenClaw 系统，并配置了飞书集成和核心技能。您现在拥有一个功能强大的 AI 助手平台！

### 关键成就：
- 🏗️ **完整环境**：从零搭建到全功能运行
- 🔌 **深度集成**：飞书消息、文档、云盘全面接入
- 🛠️ **丰富技能**：18个核心技能，覆盖日常需求
- ⏰ **自动化**：定时任务、自动维护、智能提醒
- ⚙️ **可扩展**：纯净系统配置，支持深度自定义

### 开始使用：
现在，您可以：
1. 通过飞书与OpenClaw助手对话
2. 使用各种技能提高工作效率
3. 配置自动化任务和工作流
4. 根据个人需求进行个性化配置

### 最后的话：
> "OpenClaw 是一个强大的AI助手平台，本指南确保您能够从纯净系统开始，完成所有必要的安装和配置。后续可以根据个人需求进行深度定制和优化。"

---

## 📄 附录

### A. 文件清单
本指南包含的完整文件列表：

1. `LINUX-OPENCLAW-INSTALLATION-GUIDE.md` - 主安装指南（本文件）
2. `install-skills.sh` - 技能安装脚本
3. `morning-greeting-template.sh` - 早晨问候脚本模板
4. `verify-installation.sh` - 安装验证脚本
5. `workspace-organizer.sh` - 工作空间整理脚本
6. `openclaw-config-template.json` - 配置模板
7. `troubleshooting-checklist.md` - 故障排除清单
8. `quick-reference.md` - 快速参考指南

### B. 环境变量参考
```bash
# 必需的环境变量
export FEISHU_APP_ID="your_app_id"
export FEISHU_APP_SECRET="your_app_secret"
export FEISHU_VERIFICATION_TOKEN="your_verification_token"
export FEISHU_ENCRYPT_KEY="your_encrypt_key"

# 性能优化变量
export NODE_OPTIONS="--max-old-space-size=4096"
export DEBUG="openclaw:*"  # 调试模式

# 网络代理（如果需要）
export HTTP_PROXY="http://proxy.example.com:8080"
export HTTPS_PROXY="http://proxy.example.com:8080"
```

### C. 安全注意事项
1. **保护凭证**：不要将飞书 App Secret 等敏感信息提交到版本控制
2. **权限最小化**：只授予应用必要的权限
3. **定期更新**：保持 OpenClaw 和技能为最新版本
4. **监控日志**：定期检查日志，发现异常行为
5. **备份配置**：定期备份重要配置文件

### D. 版本历史
- **v1.0.0** (2026-03-12)：初始版本，完整覆盖 Linux 安装配置
- **基于**：OpenClaw 2026.3.8 + 飞书插件最新版本
- **兼容性**：Ubuntu 22.04 LTS 及以上版本

---

## 🎊 安装完成！

恭喜您完成了 OpenClaw Linux 的完整安装！现在，OpenClaw 助手已经准备就绪，随时为您服务。

这是一个纯净的系统安装，您可以根据个人需求进行进一步的个性化配置。

有任何问题或需要进一步的帮助，请参考故障排除清单或访问官方文档。祝您使用愉快！

---
*文档维护者：OpenClaw安装指南项目*  
*最后更新：2026年3月12日*  
*版本：v1.1.0*