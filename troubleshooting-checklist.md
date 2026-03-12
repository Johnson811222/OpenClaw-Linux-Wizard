# OpenClaw Linux 故障排除清单

## 📋 文档概述
本文档提供了OpenClaw在Linux系统上安装和使用过程中常见问题的解决方案。按照问题分类，从简单到复杂逐步排查。

## 🚨 紧急问题（系统无法启动）

### 问题1：OpenClaw完全无法启动
**症状**：`openclaw --version` 无输出或报错

**排查步骤**：
1. ✅ 检查Node.js安装
   ```bash
   node --version  # 应该显示v18.x.x或更高
   npm --version   # 应该显示9.x.x或更高
   ```

2. ✅ 重新安装OpenClaw
   ```bash
   # 卸载
   npm uninstall -g openclaw
   
   # 清理缓存
   npm cache clean --force
   
   # 重新安装
   npm install -g openclaw
   ```

3. ✅ 检查环境变量
   ```bash
   # 检查npm全局路径
   npm config get prefix
   
   # 确保路径在PATH中
   echo $PATH
   ```

**解决方案**：
- 如果Node.js未安装，使用NodeSource仓库安装
- 如果PATH问题，添加npm全局路径到~/.bashrc
- 检查用户权限，避免使用root用户

### 问题2：Gateway服务启动失败
**症状**：`openclaw gateway start` 失败

**排查步骤**：
1. ✅ 检查端口占用
   ```bash
   # 检查3000端口是否被占用
   sudo netstat -tlnp | grep :3000
   
   # 如果被占用，停止相关进程或修改端口
   ```

2. ✅ 检查权限问题
   ```bash
   # 检查目录权限
   ls -la ~/.openclaw/
   
   # 修改权限
   chmod 755 ~/.openclaw
   ```

3. ✅ 查看详细日志
   ```bash
   openclaw gateway logs --follow
   ```

**解决方案**：
- 修改配置文件中的端口号
- 关闭占用端口的程序
- 检查防火墙设置，允许3000端口

## 🔌 连接问题（飞书相关）

### 问题3：飞书连接测试失败
**症状**：`openclaw feishu test` 返回错误

**排查步骤**：
1. ✅ 检查环境变量
   ```bash
   # 检查所有必需的飞书环境变量
   echo $FEISHU_APP_ID
   echo $FEISHU_APP_SECRET
   echo $FEISHU_VERIFICATION_TOKEN
   ```

2. ✅ 验证飞书应用配置
   - 确认应用已发布
   - 确认权限已正确配置
   - 确认事件订阅URL正确

3. ✅ 检查网络连接
   ```bash
   # 测试到飞书服务器的连接
   curl -I https://open.feishu.cn
   
   # 如果有代理，检查代理设置
   echo $HTTP_PROXY
   echo $HTTPS_PROXY
   ```

**解决方案**：
- 重新设置环境变量
- 在飞书开放平台重新获取凭证
- 配置网络代理（如果需要）

### 问题4：无法发送/接收消息
**症状**：消息发送失败或收不到回复

**排查步骤**：
1. ✅ 检查用户ID
   ```bash
   # 确认使用的是正确的open_id
   openclaw feishu test
   ```

2. ✅ 检查应用权限
   ```bash
   # 查看当前权限
   openclaw feishu scopes
   ```

3. ✅ 检查消息格式
   ```bash
   # 测试简单消息
   openclaw feishu send --user "ou_xxx" --message "测试"
   ```

**解决方案**：
- 确保应用有`im:message`权限
- 确认用户ID正确
- 检查消息内容是否符合飞书限制

## 🛠️ 技能问题

### 问题5：技能安装失败
**症状**：`clawhub install` 失败

**排查步骤**：
1. ✅ 检查ClawHub安装
   ```bash
   clawhub --version
   ```

2. ✅ 检查网络连接
   ```bash
   # 测试到GitHub的连接
   curl -I https://github.com
   ```

3. ✅ 检查磁盘空间和权限
   ```bash
   # 检查技能目录权限
   ls -la ~/.openclaw/workspace/skills/
   ```

**解决方案**：
- 更新ClawHub：`npm update -g clawhub`
- 使用镜像源（国内用户）：
  ```bash
  npm config set registry https://registry.npmmirror.com
  ```
- 手动安装技能：
  ```bash
  cd ~/.openclaw/workspace/skills
  git clone https://github.com/openclaw/skill-xxx.git
  ```

### 问题6：技能运行异常
**症状**：技能可以安装但运行报错

**排查步骤**：
1. ✅ 检查技能依赖
   ```bash
   # 查看技能目录下的package.json
   cat ~/.openclaw/workspace/skills/skill-name/package.json
   ```

2. ✅ 检查技能配置
   ```bash
   # 查看技能文档
   openclaw skill info skill-name
   ```

3. ✅ 启用调试模式
   ```bash
   export DEBUG="openclaw:*"
   openclaw skill run skill-name --action test
   ```

**解决方案**：
- 安装缺失的依赖
- 检查技能要求的系统工具是否已安装
- 查看技能特定的配置要求

## 📁 文件操作问题

### 问题7：无法创建/修改文件
**症状**：文件操作权限被拒绝

**排查步骤**：
1. ✅ 检查沙箱配置
   ```bash
   # 查看配置文件
   grep "allowFileSystem" ~/.openclaw/config.json
   ```

2. ✅ 检查目录权限
   ```bash
   # 检查工作空间目录权限
   ls -la ~/.openclaw/
   ```

3. ✅ 检查SELinux/AppArmor
   ```bash
   # 检查SELinux状态
   getenforce
   
   # 临时禁用测试
   sudo setenforce 0
   ```

**解决方案**：
- 修改配置文件，启用文件系统权限
- 调整目录权限：
  ```bash
  chmod -R 755 ~/.openclaw
  ```
- 配置SELinux/AppArmor例外

### 问题8：文件路径问题
**症状**：路径相关错误，文件找不到

**排查步骤**：
1. ✅ 检查路径格式
   ```bash
   # Linux路径使用正斜杠
   echo "正确: /home/$USER/.openclaw"
   echo "错误: C:\Users\$USER\.openclaw"
   ```

2. ✅ 检查当前工作目录
   ```bash
   pwd
   cd ~/.openclaw/workspace
   ```

3. ✅ 使用绝对路径
   ```bash
   # 避免相对路径问题
   full_path="/home/$USER/.openclaw/workspace/file.txt"
   ```

**解决方案**：
- 始终使用绝对路径
- 使用变量构建路径：
  ```bash
  path="$HOME/.openclaw/workspace/file.txt"
  ```
- 检查路径中的特殊字符

## ⏰ 定时任务问题

### 问题9：定时任务不执行
**症状**：配置的定时任务没有按计划运行

**排查步骤**：
1. ✅ 检查cron服务
   ```bash
   # 查看cron服务状态
   systemctl status cron
   
   # 重启cron服务
   sudo systemctl restart cron
   ```

2. ✅ 检查cron任务
   ```bash
   # 查看当前用户的cron任务
   crontab -l
   ```

3. ✅ 手动测试脚本
   ```bash
   # 手动运行脚本测试
   bash /path/to/morning-greeting.sh
   ```

**解决方案**：
- 重新添加cron任务
- 检查脚本执行权限：
  ```bash
  chmod +x /path/to/script.sh
  ```
- 确保脚本路径正确

### 问题10：任务执行但无效果
**症状**：任务执行了但没有达到预期效果

**排查步骤**：
1. ✅ 检查脚本日志
   ```bash
   # 查看脚本生成的日志文件
   cat /path/to/morning-greeting.log
   ```

2. ✅ 检查环境变量
   ```bash
   # cron中的环境变量可能不同
   # 在脚本开头添加环境变量检查
   echo "PATH: $PATH" >> /tmp/cron-debug.log
   ```

3. ✅ 检查依赖关系
   ```bash
   # 脚本依赖的工具是否在PATH中
   which node
   which openclaw
   ```

**解决方案**：
- 在脚本中使用绝对路径
- 在cron任务中设置环境变量
- 添加详细的日志记录

## 🐛 常见错误代码和解决方案

### 错误代码：ECONNREFUSED
**含义**：连接被拒绝

**可能原因**：
- Gateway服务未运行
- 端口被占用
- 防火墙阻止

**解决方案**：
```bash
# 重启Gateway
openclaw gateway stop
openclaw gateway start

# 或修改端口
# 编辑 ~/.openclaw/config.json 修改端口号
```

### 错误代码：EACCES
**含义**：权限被拒绝

**可能原因**：
- 文件/目录权限不足
- SELinux/AppArmor限制
- 用户权限不足

**解决方案**：
```bash
# 调整权限
chmod -R 755 ~/.openclaw

# 检查SELinux
getenforce
sudo setenforce 0  # 临时禁用测试
```

### 错误代码：ENOENT
**含义**：文件或目录不存在

**可能原因**：
- 路径错误
- 文件被删除
- 工作空间未初始化

**解决方案**：
```bash
# 初始化工作空间
openclaw init

# 或手动创建目录
mkdir -p ~/.openclaw/workspace
```

### 错误代码：ETIMEDOUT
**含义**：连接超时

**可能原因**：
- 网络问题
- 服务器响应慢
- 代理配置问题

**解决方案**：
```bash
# 增加超时时间
export OPENCLAW_TIMEOUT=60000

# 检查网络
curl -I https://open.feishu.cn
```

## 🔧 高级调试技巧

### 启用详细日志
```bash
# 设置调试环境变量
export DEBUG="openclaw:*"
export NODE_DEBUG="net,http,tls"

# 启动Gateway并查看日志
openclaw gateway start
openclaw gateway logs --follow
```

### 使用strace跟踪系统调用
```bash
# 跟踪OpenClaw进程
strace -f -o openclaw.log openclaw gateway start
```

### 网络诊断
```bash
# 使用tcpdump进行网络抓包
sudo tcpdump -i any port 3000 -w openclaw.pcap

# 或使用tshark
sudo tshark -i any -f "port 3000" -w openclaw.pcap
```

### 性能分析
```bash
# 监控Node.js内存使用
node --inspect-brk -e "require('openclaw')"

# 使用Chrome DevTools连接调试
# chrome://inspect
```

## 📞 获取帮助

### 官方资源
- **文档**：https://docs.openclaw.ai
- **GitHub**：https://github.com/openclaw/openclaw/issues
- **Discord**：https://discord.com/invite/clawd

### 社区支持
1. 在GitHub Issues中搜索类似问题
2. 在Discord社区提问
3. 查看飞书插件文档

### 提供调试信息
当寻求帮助时，请提供：
```bash
# 系统信息
lsb_release -a
uname -a

# OpenClaw信息
openclaw --version
openclaw gateway status

# 错误日志
openclaw gateway logs --tail 50

# 配置文件（脱敏后）
grep -v "appSecret\|encryptKey" ~/.openclaw/config.json
```

## 🎯 预防性维护

### 定期检查清单
**每日**：
- [ ] 检查Gateway服务状态
- [ ] 验证飞书连接
- [ ] 查看错误日志

**每周**：
- [ ] 备份配置文件
- [ ] 清理日志文件
- [ ] 检查技能更新
- [ ] 整理工作空间

**每月**：
- [ ] 更新Node.js和npm
- [ ] 更新OpenClaw
- [ ] 审查安全设置
- [ ] 测试完整功能链

### 备份策略
```bash
# 备份脚本示例
backup_dir="$HOME/OpenClaw-Backups/$(date '+%Y-%m')"
mkdir -p "$backup_dir"

# 备份配置文件
cp ~/.openclaw/config.json "$backup_dir/"

# 备份工作空间
tar -czf "$backup_dir/workspace-backup.tar.gz" -C ~/.openclaw/workspace .

# 备份技能
clawhub list > "$backup_dir/skills-list.txt"
```

## 🎉 成功标志
当以下所有检查通过时，说明系统运行正常：

1. ✅ `openclaw --version` 显示版本号
2. ✅ `openclaw gateway status` 显示运行中
3. ✅ `openclaw feishu test` 返回成功
4. ✅ 能发送和接收飞书消息
5. ✅ 核心技能能正常运行
6. ✅ 定时任务按计划执行

---

## 📄 更新记录
- **v1.0.0** (2026-03-12)：初始版本，基于OpenClaw 2026.3.8
- **维护者**：开心豆 😊
- **最后更新**：2026年3月12日

> 💡 **提示**：遇到问题时，先尝试最简单的解决方案，逐步深入。大多数问题都可以通过检查配置、权限和网络连接解决。