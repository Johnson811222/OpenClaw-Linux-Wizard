#!/bin/bash

# 早晨问候脚本模板
# 功能：每天7:00发送通用早晨问候
# 说明：这是一个模板脚本，用户需要根据实际情况进行配置

echo "🌅 早晨问候脚本启动..."
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 配置信息 - 用户需要修改这些配置
USER_ID="YOUR_FEISHU_USER_ID"              # 用户的飞书用户ID（需要修改）
ENABLE_WEATHER=true                        # 是否包含天气信息
LOCATION="北京"                            # 天气查询地点（根据需要修改）
CUSTOM_GREETING=false                      # 是否使用自定义问候语
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"   # 脚本所在目录

# 获取当前时间信息
current_time=$(date '+%H:%M')
hour=$(date '+%H')
minute=$(date '+%M')
day_of_week=$(date '+%u')
date_str=$(date '+%Y年%-m月%-d日')

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

# 根据时间生成通用问候语
if [ "$hour" -lt 12 ]; then
    time_greeting="早上好"
elif [ "$hour" -lt 18 ]; then
    time_greeting="下午好"
else
    time_greeting="晚上好"
fi

# 生成通用问候部分
greeting_section="🌅 **$time_greeting！** 

今天是 **$date_str $weekday**，现在是 **$current_time**。

新的一天开始了，祝您今天工作顺利，心情愉快！"

# 天气信息部分（如果启用）
weather_section=""
if [ "$ENABLE_WEATHER" = true ]; then
    echo "🌤️  获取天气信息..."
    weather_info=$(openclaw skill run weather --location "$LOCATION" 2>/dev/null)
    
    if [ -n "$weather_info" ]; then
        weather_section="

🌤️ **今日天气 - $LOCATION**
$weather_info

👕 穿衣建议：根据天气情况选择合适的衣物。"
    else
        weather_section="

🌤️ **天气提示**
今天记得查看实时天气预报。"
    fi
fi

# 今日提醒部分（通用）
reminder_section="

📋 **今日提醒**
1. 检查今日重要事项
2. 合理安排工作时间
3. 注意休息，保持精力
4. 完成计划中的任务"

# 组合完整消息
full_message="$greeting_section
$weather_section
$reminder_section

---
*OpenClaw助手*
*发送时间：$(date '+%H:%M')*"

echo "📝 生成问候消息完成"
echo "消息长度: ${#full_message} 字符"
echo ""

# 检查配置
if [ "$USER_ID" = "YOUR_FEISHU_USER_ID" ]; then
    echo "❌ 配置错误：请先修改脚本中的 USER_ID 配置"
    echo "   打开脚本文件，找到 USER_ID 配置项并修改为您的飞书用户ID"
    exit 1
fi

# 发送消息
echo "📤 发送消息到飞书..."
echo "  目标用户: $USER_ID"
echo "  正在发送..."

# 检查OpenClaw是否可用
if ! command -v openclaw &> /dev/null; then
    echo "❌ OpenClaw 未找到，请确保已正确安装"
    exit 1
fi

# 发送消息
if openclaw feishu send --user "$USER_ID" --message "$full_message" 2>&1; then
    echo "✅ 消息发送成功！"
    echo "  时间: $(date '+%H:%M:%S')"
    
    # 记录日志
    log_entry="[$(date '+%Y-%m-%d %H:%M:%S')] 早晨问候发送成功
用户: $USER_ID
消息长度: ${#full_message} 字符"
    echo "$log_entry" >> "$SCRIPT_DIR/morning-greeting.log"
    
else
    echo "❌ 消息发送失败"
    
    # 记录错误日志
    error_log="[$(date '+%Y-%m-%d %H:%M:%S')] 早晨问候发送失败
用户: $USER_ID"
    echo "$error_log" >> "$SCRIPT_DIR/morning-greeting-error.log"
fi

echo ""
echo "========================================"
echo "      脚本执行完成"
echo "========================================"

# 显示配置说明
echo ""
echo "🔧 配置说明：" 
echo "  1. 修改 USER_ID: 设置为您的飞书用户ID"
echo "  2. 修改 LOCATION: 设置您所在的城市"
echo "  3. 启用/禁用天气: 设置 ENABLE_WEATHER=true/false"
echo "  4. 自定义问候语: 设置 CUSTOM_GREETING=true 并修改问候内容"

echo ""
echo "💡 使用建议："
echo "  1. 通过cron设置定时执行"
echo "  2. 定期检查日志文件，确保发送正常"
echo "  3. 根据个人需求自定义问候内容"

# 短暂暂停
sleep 2