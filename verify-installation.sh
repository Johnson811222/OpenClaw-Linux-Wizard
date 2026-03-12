#!/bin/bash

# OpenClaw Linux 安装验证脚本
# 作者：开心豆
# 日期：2026年3月12日
# 功能：验证OpenClaw在Linux上的完整安装

echo "========================================"
echo "    OpenClaw Linux 安装验证"
echo "========================================"
echo ""

# 验证结果跟踪
validation_results=()

add_validation_result() {
    local component="$1"
    local status="$2"
    local message="$3"
    local is_critical="${4:-false}"
    
    local timestamp=$(date '+%H:%M:%S')
    
    validation_results+=("$component|$status|$message|$is_critical|$timestamp")
    
    # 显示结果
    local color
    local symbol
    
    case "$status" in
        "PASS") color="32" symbol="✅" ;;  # 绿色
        "WARN") color="33" symbol="⚠️ " ;;  # 黄色
        "FAIL") color="31" symbol="❌" ;;  # 红色
        "INFO") color="90" symbol="ℹ️ " ;;  # 灰色
        *) color="37" symbol="•" ;;        # 白色
    esac
    
    printf "\e[${color}m%s %s: %s\e[0m\n" "$symbol" "$component" "$message"
}

echo "🔍 开始系统验证..."
echo ""

# ==================== 第1部分：系统环境检查 ====================
echo "1. 系统环境检查"
echo "----------------"

# 1.1 检查Linux发行版
if command -v lsb_release &> /dev/null; then
    os_info=$(lsb_release -d | cut -f2)
    add_validation_result "Linux发行版" "PASS" "$os_info" "true"
else
    os_info=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)
    if [ -n "$os_info" ]; then
        add_validation_result "Linux发行版" "PASS" "$os_info" "true"
    else
        add_validation_result "Linux发行版" "WARN" "无法获取发行版信息" "false"
    fi
fi

# 1.2 检查内核版本
kernel_version=$(uname -r)
add_validation_result "内核版本" "INFO" "$kernel_version" "false"

# 1.3 检查内存
if command -v free &> /dev/null; then
    total_mem=$(free -h | grep Mem | awk '{print $2}')
    add_validation_result "系统内存" "INFO" "$total_mem" "false"
else
    add_validation_result "系统内存" "INFO" "无法获取内存信息" "false"
fi

# 1.4 检查磁盘空间
if command -v df &> /dev/null; then
    disk_space=$(df -h / | tail -1 | awk '{print $4}')
    add_validation_result "磁盘空间" "INFO" "根分区剩余 $disk_space" "false"
else
    add_validation_result "磁盘空间" "INFO" "无法获取磁盘空间信息" "false"
fi

# 1.5 检查当前用户
current_user=$(whoami)
if [ "$current_user" = "root" ]; then
    add_validation_result "当前用户" "WARN" "root用户（建议使用普通用户）" "false"
else
    add_validation_result "当前用户" "PASS" "$current_user" "false"
fi

echo ""

# ==================== 第2部分：基础软件检查 ====================
echo "2. 基础软件检查"
echo "----------------"

# 2.1 检查Node.js
if command -v node &> /dev/null; then
    node_version=$(node --version)
    node_major=$(echo "$node_version" | sed 's/^v\([0-9]*\).*/\1/')
    if [ "$node_major" -ge 18 ]; then
        add_validation_result "Node.js" "PASS" "$node_version" "true"
    else
        add_validation_result "Node.js" "FAIL" "$node_version，需要v18或更高" "true"
    fi
else
    add_validation_result "Node.js" "FAIL" "未安装" "true"
fi

# 2.2 检查npm
if command -v npm &> /dev/null; then
    npm_version=$(npm --version)
    add_validation_result "npm" "PASS" "$npm_version" "true"
else
    add_validation_result "npm" "FAIL" "未安装" "true"
fi

# 2.3 检查Git
if command -v git &> /dev/null; then
    git_version=$(git --version | cut -d' ' -f3)
    add_validation_result "Git" "PASS" "$git_version" "false"
else
    add_validation_result "Git" "WARN" "未安装（某些技能可能需要）" "false"
fi

echo ""

# ==================== 第3部分：OpenClaw核心检查 ====================
echo "3. OpenClaw核心检查"
echo "-------------------"

# 3.1 检查OpenClaw CLI
if command -v openclaw &> /dev/null; then
    openclaw_version=$(openclaw --version 2>/dev/null || echo "未知版本")
    add_validation_result "OpenClaw CLI" "PASS" "$openclaw_version" "true"
else
    add_validation_result "OpenClaw CLI" "FAIL" "未安装" "true"
fi

# 3.2 检查OpenClaw Gateway
if openclaw gateway status &>/dev/null; then
    add_validation_result "OpenClaw Gateway" "PASS" "服务运行正常" "true"
else
    add_validation_result "OpenClaw Gateway" "FAIL" "服务未运行" "true"
fi

# 3.3 检查工作空间目录
workspace_path="$HOME/.openclaw/workspace"
if [ -d "$workspace_path" ]; then
    add_validation_result "工作空间" "PASS" "目录存在: $workspace_path" "false"
else
    add_validation_result "工作空间" "WARN" "目录不存在，运行\`openclaw init\`创建" "false"
fi

# 3.4 检查配置文件
config_path="$HOME/.openclaw/config.json"
if [ -f "$config_path" ]; then
    add_validation_result "配置文件" "PASS" "存在: $config_path" "false"
else
    add_validation_result "配置文件" "WARN" "不存在，需要创建" "false"
fi

echo ""

# ==================== 第4部分：飞书插件检查 ====================
echo "4. 飞书插件检查"
echo "----------------"

# 4.1 检查飞书环境变量
required_env_vars=("FEISHU_APP_ID" "FEISHU_APP_SECRET" "FEISHU_VERIFICATION_TOKEN")
missing_vars=()

for var in "${required_env_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -eq 0 ]; then
    add_validation_result "飞书环境变量" "PASS" "所有必需变量已设置" "true"
else
    add_validation_result "飞书环境变量" "FAIL" "缺少变量: ${missing_vars[*]}" "true"
fi

# 4.2 测试飞书连接
if openclaw feishu test &>/dev/null; then
    add_validation_result "飞书连接" "PASS" "连接正常" "true"
else
    add_validation_result "飞书连接" "FAIL" "连接失败" "true"
fi

echo ""

# ==================== 第5部分：技能检查 ====================
echo "5. 技能检查"
echo "-------------"

# 5.1 检查ClawHub
if command -v clawhub &> /dev/null; then
    clawhub_version=$(clawhub --version 2>/dev/null || echo "未知版本")
    add_validation_result "ClawHub" "PASS" "$clawhub_version" "false"
else
    add_validation_result "ClawHub" "WARN" "未安装，技能管理需要" "false"
fi

# 5.2 检查核心技能目录
skills_path="$HOME/.openclaw/workspace/skills"
if [ -d "$skills_path" ]; then
    skill_count=$(find "$skills_path" -maxdepth 1 -type d | wc -l)
    skill_count=$((skill_count - 1))  # 减去当前目录
    add_validation_result "技能目录" "PASS" "存在，包含${skill_count}个技能" "false"
else
    add_validation_result "技能目录" "WARN" "不存在，运行技能安装脚本" "false"
fi

# 5.3 检查关键技能
critical_skills=("feishu-doc" "file-manager" "brave-search")
for skill in "${critical_skills[@]}"; do
    skill_path="$skills_path/$skill"
    if [ -d "$skill_path" ]; then
        add_validation_result "技能: $skill" "PASS" "已安装" "false"
    else
        add_validation_result "技能: $skill" "WARN" "未安装" "false"
    fi
done

echo ""

# ==================== 第6部分：总结报告 ====================
echo "6. 验证总结报告"
echo "----------------"

# 统计结果
total=${#validation_results[@]}
pass=0
warn=0
fail=0
info=0
critical_fails=0

for result in "${validation_results[@]}"; do
    IFS='|' read -r component status message is_critical timestamp <<< "$result"
    
    case "$status" in
        "PASS") ((pass++)) ;;
        "WARN") ((warn++)) ;;
        "FAIL") 
            ((fail++))
            if [ "$is_critical" = "true" ]; then
                ((critical_fails++))
            fi
            ;;
        "INFO") ((info++)) ;;
    esac
done

echo "📊 验证统计："
echo "  总计检查: $total 项"
printf "  通过: \e[32m%s 项\e[0m\n" "$pass"
printf "  警告: \e[33m%s 项\e[0m\n" "$warn"
printf "  失败: \e[31m%s 项\e[0m\n" "$fail"
echo "  信息: $info 项"

echo ""

if [ $critical_fails -gt 0 ]; then
    echo "❌ 关键问题发现："
    for result in "${validation_results[@]}"; do
        IFS='|' read -r component status message is_critical timestamp <<< "$result"
        if [ "$status" = "FAIL" ] && [ "$is_critical" = "true" ]; then
            echo "  • $component: $message"
        fi
    done
    echo ""
    echo "⚠️  安装存在问题，需要解决上述关键问题后才能正常使用。"
elif [ $fail -gt 0 ]; then
    echo "⚠️  存在非关键问题，建议修复以获得更好体验。"
else
    echo "✅ 所有关键检查通过！OpenClaw 可以正常使用。"
fi

echo ""

# 提供建议
echo "🔧 建议操作："
if [ $critical_fails -gt 0 ]; then
    echo "  1. 解决所有关键失败项（红色标记）"
fi
if [ $warn -gt 0 ]; then
    echo "  2. 处理警告项（黄色标记）以优化体验"
fi
echo "  3. 运行技能安装脚本: ./install-skills.sh"
echo "  4. 测试消息发送: openclaw feishu send --message '测试'"
echo "  5. 配置定时任务（参考主指南）"

echo ""

# 保存详细报告
report_path="$(pwd)/validation-report-$(date '+%Y%m%d-%H%M%S').txt"

report_content="OpenClaw Linux 安装验证报告
生成时间: $(date '+%Y-%m-%d %H:%M:%S')
系统: $os_info

验证结果统计:
  总计: $total 项
  通过: $pass 项
  警告: $warn 项  
  失败: $fail 项
  信息: $info 项

详细结果:"

for result in "${validation_results[@]}"; do
    IFS='|' read -r component status message is_critical timestamp <<< "$result"
    report_content="$report_content
$component | $status | $message | $timestamp"
done

report_content="$report_content

建议:
$(if [ $critical_fails -gt 0 ]; then
    echo "存在关键问题，需要立即解决："
    for result in "${validation_results[@]}"; do
        IFS='|' read -r component status message is_critical timestamp <<< "$result"
        if [ "$status" = "FAIL" ] && [ "$is_critical" = "true" ]; then
            echo "• $component: $message"
        fi
    done
elif [ $fail -gt 0 ]; then
    echo "存在非关键问题，建议修复。"
else
    echo "所有检查通过，系统可以正常使用。"
fi)"

echo "$report_content" > "$report_path"
echo "📄 详细报告已保存: $report_path"

echo ""
echo "========================================"
echo "      验证完成 - 开心豆 😊"
echo "========================================"

# 等待用户输入
echo ""
read -p "按回车键退出..."