#!/bin/bash

# OpenClaw 技能安装脚本 for Linux
# 作者：开心豆
# 日期：2026年3月12日

echo "========================================"
echo "      OpenClaw 技能安装脚本"
echo "========================================"
echo ""

# 检查是否以root身份运行
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  不建议以root身份运行此脚本"
    echo "   请使用普通用户运行"
    exit 1
fi

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
    clawhub_version=$(clawhub --version 2>/dev/null || echo "未知版本")
    echo "  ✅ ClawHub 已安装: $clawhub_version"
else
    echo "  ❌ ClawHub 未安装，正在安装..."
    if npm install -g clawhub; then
        echo "  ✅ ClawHub 安装完成"
    else
        echo "  ❌ ClawHub 安装失败"
        exit 1
    fi
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
    
    printf "[%3d%%] 安装技能: %-20s" "$progress" "$skill"
    
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
echo ""

# 提供后续步骤建议
echo "📋 后续步骤建议："
echo "  1. 验证飞书连接: openclaw feishu test"
echo "  2. 测试消息发送: openclaw feishu send --message '测试消息'"
echo "  3. 整理工作空间: openclaw skill run file-manager --action organize"
echo "  4. 配置定时任务: 参考主指南的定时任务部分"

echo ""
echo "💡 提示："
echo "  - 如果某些技能安装失败，可以单独重试: clawhub install <技能名>"
echo "  - 查看技能详情: clawhub info <技能名>"
echo "  - 搜索更多技能: clawhub search <关键词>"

echo ""
echo "========================================"
echo "      脚本执行完成 - 开心豆 😊"
echo "========================================"

# 等待用户输入
echo ""
read -p "按回车键退出..."