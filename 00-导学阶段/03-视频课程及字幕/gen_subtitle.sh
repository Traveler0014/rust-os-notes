#!/bin/bash

# Whisper命令配置，可以根据需求调整参数
whisper_cmd() {
    whisper --temperature_increment_on_fallback None \
     --condition_on_previous_text False \
     --beam_size 15 \
     --patience 1.0 \
     --compression_ratio_threshold 3.0 \
     --logprob_threshold 0.0 \
     --no_speech_threshold 0.7 \
     --word_timestamps True \
     --max_words_per_line 25 \
     --output_format srt \
     --model medium \
     --language zh "$1" -o "$2"
}

# 主处理函数
process_files() {
    local directory="$1"  # 接收文件夹路径作为参数
    local file_extension="$2"  # 接收文件扩展名作为参数
    local subtitle_extension="$3"  # 接收字幕文件扩展名作为参数

    # 遍历指定目录下的所有指定扩展名的文件
    for file in "$directory"/*."$file_extension"; do
        if [[ -f "$file" ]]; then  # 确保是文件而非目录
            local base=${file%.$file_extension}
            local subtitle_file="$base.$subtitle_extension"

            if [ ! -f "$subtitle_file" ]; then
                echo "为文件 $file 生成字幕..."
#                 whisper_cmd "$file" "$subtitle_file"
                whisper_cmd "$file" "./"
            else
                echo "字幕文件 $subtitle_file 已存在。"
            fi
        fi
    done
}

echo "开始处理..."
process_files "." "mp4" "srt"
echo "处理完毕。"

