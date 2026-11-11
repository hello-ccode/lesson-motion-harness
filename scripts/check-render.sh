#!/usr/bin/env bash
# 렌더가 끝난 영상을 재서 critic이 판정할 재료를 출력한다. 판정은 이 스크립트가 하지 않는다 (docs/check.md).
# 쓰는 법: bash scripts/check-render.sh 영상.mp4
# 재는 것: ① 3초 이상 화면 정지  ② 1.5초 이상 무음  ③ 음량(I · TP)  ④ 1초마다 평균 밝기
# 기준값 출처: docs/check.md 1장 (1주차 motion.md 6절 · 4절, docs/video.md 2장)
set -e
F="$1"; [ -f "$F" ] || { echo "영상 파일을 주세요: bash scripts/check-render.sh 영상.mp4"; exit 1; }
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$F")
echo "== 영상 길이: ${DUR}초"

# 구간 출력: "시작 ~ 끝 (길이)". 끝까지 이어지면 영상 길이를 끝으로 본다.
ranges() { awk -v dur="$DUR" '
  /_start: / { match($0, /_start: [0-9.]+/); s=substr($0, RSTART+8, RLENGTH-8); open=1 }
  /_end: /   { match($0, /_end: [0-9.]+/); e=substr($0, RSTART+6, RLENGTH-6); printf "  %.2f ~ %.2f초 (%.2f초)\n", s, e, e-s; open=0; n++ }
  END { if (open) { printf "  %.2f ~ %.2f초 (%.2f초, 영상 끝까지 이어짐)\n", s, dur, dur-s; n++ }
        if (!n) print "  없음" }'; }

echo "== ① 3초 이상 화면 정지 (freezedetect=n=-80dB:d=3)"
ffmpeg -hide_banner -nostats -i "$F" -vf "freezedetect=n=-80dB:d=3" -an -f null - 2>&1 \
  | grep -E "freeze_(start|end):" | ranges

echo "== ② 1.5초 이상 무음 (silencedetect=noise=-40dB:d=1.5)"
ffmpeg -hide_banner -nostats -i "$F" -af "silencedetect=noise=-40dB:d=1.5" -vn -f null - 2>&1 \
  | grep -E "silence_(start|end):" | ranges

echo "== ③ 음량 (loudnorm 목표 I=-16 TP=-1.5 LRA=11, 지금 영상의 값)"
ffmpeg -hide_banner -nostats -i "$F" -af "loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json" -vn -f null - 2>&1 \
  | grep -E '"input_(i|tp|lra)"' | sed 's/[",]//g; s/^[[:space:]]*/  /'

echo "== ④ 평균 밝기 (1초마다, 0~255. 179 미만이면 표시)"
ffmpeg -hide_banner -nostats -i "$F" -vf "fps=1,scale=in_range=limited:out_range=full,signalstats,metadata=print:key=lavfi.signalstats.YAVG:file=-" -an -f null - 2>/dev/null \
  | awk -F'[:=]' '/pts_time/ { t=$NF } /YAVG/ { y=$NF; n++; sum+=y; if (y<179) { printf "  %s초: %.0f\n", t, y; low++ } }
                  END { printf "  평균 %.0f, 179 미만인 프레임 %d개 / %d개\n", sum/n, low+0, n }'
