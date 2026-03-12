#!/bin/bash

# OpenClaw 工作空间整理脚本 for Linux
# 作者：开心豆
# 日期：2026年3月12日
# 功能：自动整理OpenClaw工作空间，创建标准目录结构

echo "========================================"
echo "      OpenClaw 工作空间整理工具"
echo "========================================"
echo ""

# 配置
workspace_root="$HOME/.openclaw/workspace"
backup_dir="$workspace_root/backups"
timestamp=$(date '+%Y%m%d-%H%M%S')

# 标准目录结构
declare -A standard_dirs=(
    ["01-projects"]="项目目录 - 完整的项目（有明确目标和交付物）"
    ["02-tools"]="工具脚本 - 可重复使用的工具脚本"
    ["03-docs"]="文档资料 - 文档和说明文件"
    ["04-memory"]="记忆系统 - 记忆和总结文件"
    ["05-configs"]="配置文件 - 配置和身份文件"
    ["06-backups"]="备份文件 - 备份和归档文件"
    ["07-temp"]="临时文件 - 临时工作文件"
    ["08-archive"]="归档文件 - 历史项目归档"
)

show_header() {
    echo ""
    echo "=== $1 ==="
    echo ""
}

create_backup() {
    show_header "创建备份"
    
    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
        echo "✅ 创建备份目录: $backup_dir"
    fi
    
    backup_file="$backup_dir/workspace-backup-$timestamp.tar.gz"
    
    # 创建备份
    if tar -czf "$backup_file" -C "$workspace_root" . 2>/dev/null; then
        echo "✅ 工作空间备份创建成功: $backup_file"
        return 0
    else
        echo "❌ 备份创建失败"
        return 1
    fi
}

create_standard_dirs() {
    show_header "创建标准目录结构"
    
    created_count=0
    existing_count=0
    
    for dir_name in "${!standard_dirs[@]}"; do
        full_path="$workspace_root/$dir_name"
        
        if [ -d "$full_path" ]; then
            echo "   📁 $dir_name (已存在)"
            ((existing_count++))
        else
            mkdir -p "$full_path"
            echo "   ✅ $dir_name - ${standard_dirs[$dir_name]}"
            ((created_count++))
            
            # 为某些目录创建README
            case "$dir_name" in
                "01-projects"|"02-tools"|"03-docs")
                    readme_path="$full_path/README.md"
                    cat > "$readme_path" << EOF
# $dir_name

${standard_dirs[$dir_name]}

## 使用说明
- 将相关文件放入此目录
- 保持文件组织有序
- 定期清理不需要的文件

## 文件命名规范
- 使用有意义的名称
- 避免特殊字符
- 使用连字符而不是空格

---
*由OpenClaw工作空间整理工具创建*
EOF
                    ;;
            esac
        fi
    done
    
    echo ""
    echo "📊 目录创建统计："
    echo "  新建目录: $created_count 个"
    echo "  已存在目录: $existing_count 个"
    echo "  总计目录: ${#standard_dirs[@]} 个"
}

analyze_workspace() {
    show_header "分析工作空间"
    
    if [ ! -d "$workspace_root" ]; then
        echo "❌ 工作空间目录不存在: $workspace_root"
        return 1
    fi
    
    # 获取所有文件（排除备份目录）
    all_files=$(find "$workspace_root" -type f -not -path "$backup_dir/*" | wc -l)
    
    echo "📁 工作空间位置: $workspace_root"
    echo "📄 文件总数: $all_files 个"
    echo ""
    
    # 按类型统计（前10种）
    echo "📊 文件类型统计："
    find "$workspace_root" -type f -not -path "$backup_dir/*" -name "*.*" | \
        sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10 | \
        while read count extension; do
            percent=$(echo "scale=1; $count * 100 / $all_files" | bc)
            printf "   %-8s %4d 个 (%5.1f%%)\n" ".$extension" "$count" "$percent"
        done
    
    # 按目录统计（前5个）
    echo ""
    echo "📊 目录分布统计："
    find "$workspace_root" -type f -not -path "$backup_dir/*" | \
        sed "s|$workspace_root/||" | cut -d'/' -f1 | sort | uniq -c | sort -rn | head -5 | \
        while read count dir; do
            percent=$(echo "scale=1; $count * 100 / $all_files" | bc)
            printf "   %-30s %4d 个 (%5.1f%%)\n" "$dir" "$count" "$percent"
        done
    
    return 0
}

classify_files() {
    show_header "文件分类"
    
    # 这里简化处理，实际应该根据文件类型和内容分类
    echo "📊 分类功能需要根据具体文件类型实现"
    echo "  当前版本提供目录结构整理"
    echo "  文件分类功能将在后续版本中添加"
    
    return 0
}

organize_files() {
    show_header "整理文件"
    
    echo "📁 当前主要整理目录结构"
    echo "  文件移动功能将在后续版本中添加"
    echo "  当前已创建标准目录结构"
    
    return 0
}

generate_report() {
    show_header "生成整理报告"
    
    report_path="$workspace_root/workspace-organization-report-$timestamp.md"
    
    cat > "$report_path" << EOF
# OpenClaw 工作空间整理报告

## 基本信息
- **整理时间**: $(date '+%Y年%-m月%-d日 %H:%M:%S')
- **工作空间**: $workspace_root
- **备份文件**: $backup_dir/workspace-backup-$timestamp.tar.gz

## 整理统计
- **总文件数**: $(find "$workspace_root" -type f -not -path "$backup_dir/*" | wc -l) 个
- **创建目录**: ${#standard_dirs[@]} 个标准目录

## 目录结构详情

### 标准目录列表
EOF

    for dir_name in $(echo "${!standard_dirs[@]}" | tr ' ' '\n' | sort); do
        echo "- **$dir_name**: ${standard_dirs[$dir_name]}" >> "$report_path"
    done

    cat >> "$report_path" << EOF

## 目录树结构
\`
$workspace_root
EOF

    for dir_name in $(echo "${!standard_dirs[@]}" | tr ' ' '\n' | sort); do
        echo "├── $dir_name/ - ${standard_dirs[$dir_name]}" >> "$report_path"
    done

    cat >> "$report_path" << EOF
\`

## 建议和后续步骤

### 立即操作
1. **检查备份**: 确认备份文件已正确创建
2. **验证目录**: 检查标准目录结构是否完整
3. **移动文件**: 手动将文件移动到对应目录

### 长期维护
1. **定期整理**: 建议每周运行一次整理脚本
2. **文件命名**: 使用有意义的文件名，避免特殊字符
3. **目录规范**: 新项目放在 \`01-projects\` 目录下
4. **备份策略**: 重要文件定期备份到 \`06-backups\`

### 文件分类建议
- **项目文件**: 放入 \`01-projects/\` 
- **工具脚本**: 放入 \`02-tools/\`
- **文档资料**: 放入 \`03-docs/\`
- **记忆文件**: 放入 \`04-memory/\`
- **配置文件**: 放入 \`05-configs/\`
- **临时文件**: 放入 \`07-temp/\`（定期清理）
- **历史归档**: 放入 \`08-archive/\`

## 自动化整理配置

### 每周自动整理
\`\`\`bash
# 添加每周日2:00自动整理任务
(crontab -l 2>/dev/null; echo "0 2 * * 0 cd $(pwd) && ./workspace-organizer.sh") | crontab -
\`\`\`

### 手动整理命令
\`\`\`bash
# 运行整理脚本
./workspace-organizer.sh

# 只创建目录结构
./workspace-organizer.sh --dirs-only

# 只创建备份
./workspace-organizer.sh --backup-only
\`\`\`

---
*报告由 OpenClaw 工作空间整理工具生成*
*工具版本: 1.0.0*
*作者: 开心豆 😊*
EOF

    echo "✅ 整理报告已生成: $report_path"
    
    return "$report_path"
}

# ==================== 主程序 ====================
echo "开始整理工作空间..."
echo "工作空间根目录: $workspace_root"
echo ""

# 1. 创建备份
if ! create_backup; then
    echo "⚠️  备份创建失败，继续操作可能存在风险"
    read -p "是否继续？(y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "操作已取消"
        exit 0
    fi
fi

# 2. 创建标准目录
create_standard_dirs

# 3. 分析工作空间
if ! analyze_workspace; then
    echo "❌ 无法分析工作空间，操作终止"
    exit 1
fi

# 4. 分类文件（简化版）
classify_files

# 5. 整理文件（简化版）
organize_files

# 6. 生成报告
report_path=$(generate_report)

# 7. 显示总结
show_header "整理完成总结"

echo "🎉 工作空间整理完成！"
echo ""
echo "📊 最终统计："
echo "  创建标准目录: ${#standard_dirs[@]} 个"
echo "  生成整理报告: $report_path"
echo "  创建时间备份: $backup_dir/workspace-backup-$timestamp.tar.gz"

echo ""
echo "🔧 后续操作建议："
echo "  1. 查看整理报告了解详细情况"
echo "  2. 手动将文件移动到对应目录"
echo "  3. 配置每周自动整理任务（可选）"
echo "  4. 定期清理临时目录 (07-temp)"

echo ""
echo "⏰ 定时整理配置（可选）："
echo "  # 创建每周整理任务"
echo "  (crontab -l 2>/dev/null; echo \"0 2 * * 0 cd $(pwd) && ./workspace-organizer.sh\") | crontab -"

echo ""
echo "========================================"
echo "      整理完成 - 开心豆 😊"
echo "========================================"

# 等待用户输入
echo ""
read -p "按回车键退出..."