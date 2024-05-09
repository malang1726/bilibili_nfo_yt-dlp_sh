#!/bin/bash

# 默认为当前目录
folder_path="."

# 是否检测标题中的标签
detect_tags=false

# 解析命令行参数
while getopts ":gt" opt; do
  case $opt in
    g)
      detect_tags=true
      ;;
    t)
      test_mode=true
      ;;
    \?)
      echo "无效的选项: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# 如果不是测试模式，则提示用户输入目录路径
if [ ! "$test_mode" = true ]; then
    read -p "请输入目录路径: " folder_path
fi

# 检查目录下是否存在.info.json文件
info_json_files=$(find "$folder_path" -maxdepth 1 -name "*.info.json" | wc -l)
if [ "$info_json_files" -eq 0 ]; then
    echo "错误：目录中不存在.info.json文件。"
    exit 1
fi

# 打印选项供用户选择
echo "请选择平台:"
echo "1. Bilibili"
echo "2. YouTube"

# 提示用户选择
read -p "请输入数字选择平台: " platform

# 检查用户输入并执行相应操作
case $platform in
    1)
        platform_name="Bilibili"
        ;;
    2)
        platform_name="YouTube"
        echo "[当前功能还在开发阶段]"
        exit 1
        ;;
    *)
        echo "无效的选择，请输入1或2."
        exit 1
        ;;
esac

# 设置时区为Asia/Shanghai
export TZ="Asia/Shanghai"

# 递归读取目录下的.info.json文件并处理
for file in "$folder_path"/*.info.json; do
    if [ -f "$file" ]; then
        # 解析JSON并提取字段
        uploader=$(jq -r '.uploader' "$file")
        uploader_id=$(jq -r '.uploader_id' "$file")
        tags=$(jq -r '.tags[]' "$file")
        description=$(jq -r '.description' "$file")
        id=$(jq -r '.id' "$file")
        title=$(jq -r '.title' "$file")
        timestamp=$(jq -r '.timestamp' "$file")
        
        # 将Unix时间戳转换为yyyy-mm-dd格式的日期
        premiered_date=$(date -d "@$timestamp" "+%Y-%m-%d")
        
        # 提取文件名（不带扩展名）
        filename=$(basename -- "$file")
        filename_no_extension="${filename%.info.json}"
        
        # 写入.nfo文件
        echo "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>" > "$folder_path/$filename_no_extension.nfo"
        echo "<movie>" >> "$folder_path/$filename_no_extension.nfo"
        echo "    <premiered>$premiered_date</premiered>" >> "$folder_path/$filename_no_extension.nfo"
        echo "    <title>$title</title>" >> "$folder_path/$filename_no_extension.nfo"
        echo "    <sorttitle>$timestamp</sorttitle>" >> "$folder_path/$filename_no_extension.nfo"
        echo "    <tagline>$id</tagline>" >> "$folder_path/$filename_no_extension.nfo"
        echo "    <plot>$description</plot>" >> "$folder_path/$filename_no_extension.nfo"
        echo "    <studio>$uploader</studio>" >> "$folder_path/$filename_no_extension.nfo"
        
        # 将tags写入到数组中
        declare -a file_tags_list
        for tag in $tags; do
            echo "    <tag>$tag</tag>" >> "$folder_path/$filename_no_extension.nfo"
            file_tags_list+=("$tag")
        done
        
        # 如果启用了检测标题中的标签，则执行相应操作
        if [ "$detect_tags" = true ]; then
            # 匹配标题中被【】或（）()包裹的标签
            if [[ $title =~ \【([^]]+)\】 ]]; then
                # 使用正则表达式匹配
                match="${BASH_REMATCH[1]}"
                IFS='/\\' read -r -a tag_array <<< "$match"
                for tag in "${tag_array[@]}"; do
                    echo "    <tag>$tag</tag>" >> "$folder_path/$filename_no_extension.nfo"
                    file_tags_list+=("$tag")
                done
            fi
        fi
        
        echo "</movie>" >> "$folder_path/$filename_no_extension.nfo"
        
        echo "已处理文件: $filename"
        
        # 在测试模式下，
        if [ "$test_mode" = true ]; then
            echo "文件 $filename 中的tag为: $tags"
            echo "文件 $filename 中的标题提取的tag为: $match"
        fi
    fi
done
