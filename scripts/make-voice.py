"""내레이션을 문장마다 wav 한 개로 만든다 (Supertonic 3, F1, 빠르기 1.05, 내 컴퓨터에서).
값의 출처: docs/sound.md 1장 (1주차 motion.md 4절 · 제작 스크립트).

쓰는 법 (Supertonic이 깔린 파이썬으로 돌린다. 위치는 CLAUDE.local.md에만 적혀 있다):
  <supertonic 파이썬> scripts/make-voice.py out/<영상이름>/narration.json [--only s4,s3a]
  --only: 그 id 문장만 다시 만든다. 나머지 wav 와 durations.json 의 값은 그대로 둔다.
          (TTS는 돌릴 때마다 파형이 조금씩 달라서, 선생님이 이미 들은 문장을 다시 만들면 소리가 바뀐다)
narration.json 모양: {"lines": [{"id": "s1", "text": "소리 나는 대로 적은 대본"}, ...]}
결과: narration.json 옆 audio/<id>.wav 와 audio/durations.json (문장별 초)
환경변수 SUPERTONIC_DIR = Supertonic 폴더 (그 안에 models/supertonic-3). 공개 저장소에는 경로를 적지 않는다.
"""
import json
import os
import re
import sys
from pathlib import Path

VOICE, SPEED, STEPS, LANG = "F1", 1.05, 8, "ko"   # docs/sound.md 1장


def main():
    sys.stdout.reconfigure(encoding="utf-8")  # 윈도우 콘솔에서도 한글이 깨지지 않게
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    src = Path(sys.argv[1])
    only = None
    if "--only" in sys.argv:
        only = set(sys.argv[sys.argv.index("--only") + 1].split(","))
    base = os.environ.get("SUPERTONIC_DIR")
    if not base:
        sys.exit("SUPERTONIC_DIR가 없어요. CLAUDE.local.md에 적힌 Supertonic 위치를 환경변수로 준 뒤 다시 돌려 주세요.")
    from supertonic import TTS

    lines = json.loads(src.read_text(encoding="utf-8"))["lines"]
    out_dir = src.parent / "audio"
    out_dir.mkdir(parents=True, exist_ok=True)
    tts = TTS(model="supertonic-3", model_dir=Path(base) / "models" / "supertonic-3", auto_download=False)
    style = tts.get_voice_style(voice_name=VOICE)
    durations = {}
    dpath = out_dir / "durations.json"
    if only and dpath.exists():
        durations = json.loads(dpath.read_text(encoding="utf-8"))   # 안 다시 만드는 문장의 값을 지키려고 먼저 읽는다
    ids = {l["id"] for l in lines}
    if only and not only <= ids:
        sys.exit(f"narration.json 에 없는 id: {sorted(only - ids)}")
    for line in lines:
        if only and line["id"] not in only:
            continue
        text = line["text"]
        # 숫자 · 영문은 소리 나는 대로 적어야 한다 (docs/sound.md 2장 읽기 표)
        if re.search(r"[0-9A-Za-z]", text):
            print(f"주의 {line['id']}: 숫자나 영문이 있어요. 소리 나는 대로 적었는지 확인하세요 → {text}")
        wav, dur = tts.synthesize(text, voice_style=style, total_steps=STEPS, speed=SPEED, lang=LANG)
        out = out_dir / f"{line['id']}.wav"
        tts.save_audio(wav, str(out))
        durations[line["id"]] = round(float(dur[0] if hasattr(dur, "__len__") else dur), 2)
        print(f"{line['id']}: {durations[line['id']]}초 → {out}")
    dpath.write_text(json.dumps(durations, ensure_ascii=False, indent=1), encoding="utf-8")


if __name__ == "__main__":
    main()
