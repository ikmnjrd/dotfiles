#!/bin/bash

if [ -f /tmp/ffmpeg_recording.pid ]; then
    FFMPEG_PID=$(cat /tmp/ffmpeg_recording.pid)
    kill $FFMPEG_PID
    rm /tmp/ffmpeg_recording.pid
    notify-send "録画が停止されました" "ファイルを保存しました: $OUTPUT" \
        -u low -a "スクリーンレコーダー" -i media-record
else
    notify-send "録画は行われていません" \
        -u low -a "スクリーンレコーダー" -i media-record
fi

