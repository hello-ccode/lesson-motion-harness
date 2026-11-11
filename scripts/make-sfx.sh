#!/usr/bin/env bash
# 효과음 네 가지(pop · tick · marker · chime)를 FFmpeg로 합성한다. 외부 음원은 쓰지 않는다.
# 규격 출처: docs/sound.md 3장 (1주차에 만든 wav 네 개의 길이 · 주파수 · 크기를 재서 맞춤).
# 쓰는 법: bash scripts/make-sfx.sh [저장할 폴더]   (기본 src/assets/sfx)
set -e
OUT="${1:-$(cd "$(dirname "$0")/.." && pwd)/src/assets/sfx}"
mkdir -p "$OUT"
FF="ffmpeg -hide_banner -loglevel error -y"

# pop: 사인파 880Hz, 0.12초. 처음 0.04초는 그대로, 그 뒤 직선으로 줄어듦. 최대 0.075
$FF -f lavfi -i "sine=frequency=880:duration=0.12:sample_rate=44100" \
  -af "volume='0.6*if(lt(t,0.04),1,(0.12-t)/0.08)':eval=frame" -ac 1 -c:a pcm_s16le "$OUT/pop.wav"

# tick: 사인파 1600Hz, 0.07초. 빨리 줄어듦. 최대 0.10
$FF -f lavfi -i "sine=frequency=1600:duration=0.07:sample_rate=44100" \
  -af "volume='0.8*exp(-14*t)':eval=frame" -ac 1 -c:a pcm_s16le "$OUT/tick.wav"

# marker: 핑크 노이즈를 1.6~2.5kHz 띠로 걸러 0.35초. 앞 0.02초 올라가고 끝 0.1초 줄어듦. 최대 약 0.065
$FF -f lavfi -i "anoisesrc=color=pink:duration=0.35:sample_rate=48000:amplitude=0.5:seed=7" \
  -af "highpass=f=1600,lowpass=f=2500,volume='0.70*min(1,t/0.02)*min(1,(0.35-t)/0.1)':eval=frame" -ac 1 -c:a pcm_s16le "$OUT/marker.wav"

# chime: 사인파 1047Hz + 1568Hz, 1.2초. 천천히 줄어듦. 최대 0.087
$FF -f lavfi -i "sine=frequency=1047:duration=1.2:sample_rate=44100" \
    -f lavfi -i "sine=frequency=1568:duration=1.2:sample_rate=44100" \
  -filter_complex "[0:a][1:a]amix=inputs=2:normalize=0,volume='0.35*exp(-0.95*t)':eval=frame" -ac 1 -c:a pcm_s16le "$OUT/chime.wav"

echo "효과음 4개를 만들었어요: $OUT"
