#!/bin/bash

# 早晨问候脚本 - 开心豆定制版 for Linux
# 作者：开心豆
# 日期：2026年3月12日
# 功能：每天7:00发送个性化早晨问候

echo "🌅 早晨问候脚本启动..."
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 配置信息
USER_ID="ou_8156ee1158132a9df669373a9fd60275"  # Johson的飞书用户ID
ENABLE_WEATHER=true                           # 是否包含天气信息
ENABLE_NEWS=false                             # 是否包含新闻简报（可单独配置）
LOCATION="上海"                               # 天气查询地点
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"   # 脚本所在目录

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
if [ "$hour" -lt 12 ]; then
    time_greeting="早上好"
elif [ "$hour" -lt 18 ]; then
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

# 安全提醒部分（针对Johson的通勤情况）
safety_reminder="🚗 **安全驾驶提醒**
今天开车30公里到浦东张江，请注意：
• 提前检查车况，确保安全
• 保持安全车距，谨慎驾驶
• 避开高峰拥堵，规划路线
• 保持良好心态，平安到达

💡 小贴士：可以听听音乐或播客，让通勤更愉快！"

# 天气信息部分（如果启用）
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

# 检查OpenClaw和飞书插件是否可用
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

# 显示执行摘要
echo ""
echo "📊 执行摘要："
echo "  执行时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "  目标用户: $USER_ID"
echo "  包含模块: 问候、安全提醒、鼓励、早餐建议"
echo "  天气信息: $(if [ "$ENABLE_WEATHER" = true ]; then echo '已包含'; else echo '未包含'; fi)"
echo "  新闻简报: $(if [ "$ENABLE_NEWS" = true ]; then echo '已包含'; else echo '未包含'; fi)"

echo ""
echo "🔧 配置说明："
echo "  修改用户ID: 编辑脚本中的 USER_ID 变量"
echo "  启用天气: 设置 ENABLE_WEATHER=true"
echo "  更改地点: 修改 LOCATION 变量"
echo "  日志文件: $SCRIPT_DIR/morning-greeting.log"

echo ""
echo "💡 使用建议："
echo "  1. 通过cron设置每天7:00自动执行"
echo "  2. 定期检查日志文件，确保发送正常"
echo "  3. 根据季节调整问候内容和穿衣建议"
echo "  4. 可以结合新闻简报技能，添加新闻摘要"

echo ""
echo "🎉 祝你今天愉快！ - 开心豆 😊"

# 短暂暂停
sleep 3