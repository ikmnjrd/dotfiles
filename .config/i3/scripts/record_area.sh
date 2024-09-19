#!/bin/bash

OUTPUT="$HOME/Videos/recorded_$(date +%Y%m%d_%H%M%S).mp4"
AREA=$(slop -f "%x,%y %wx%h")

if [ -z "$AREA" ]; then
    echo "録画がキャンセルされました。"
    exit 1
fi

# ffmpeg で録画を開始し、PID を取得
ffmpeg -y -video_size "${AREA#* }" -framerate 25 -f x11grab -i :0.0+"${AREA% *}" "$OUTPUT" &
FFMPEG_PID=$!

# PID を一時ファイルに保存
echo $FFMPEG_PID > /tmp/ffmpeg_recording.pid

# 録画開始の通知をアクション付きで送信
notify-send "録画中..." "ここをクリックして録画を停止" \
    -u low -t 0 -a "スクリーンレコーダー" -i media-record \
    --action=stop:"録画停止"


