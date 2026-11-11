#!/usr/bin/env bash
# 부품(src/parts)과 자산(src/assets)을 영상 프로젝트(out/<영상이름>/assets/shared/)로 복사한다.
# 부품은 src/parts 에서만 고친다. 복사본은 직접 고치지 않는다 (1주차 motion.md 0-6, CLAUDE.md 규칙 2).
# 쓰는 법: bash scripts/sync-parts.sh <영상이름>     렌더 · 스냅샷 전에 매번 돌린다.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="$1"; [ -n "$NAME" ] || { echo "영상 이름을 주세요: bash scripts/sync-parts.sh <영상이름>"; exit 1; }
DEST="$ROOT/out/$NAME/assets/shared"
rm -rf "$DEST"; mkdir -p "$DEST/parts"
# 견본 사진(_check)은 복사하지 않는다
for f in "$ROOT"/src/parts/*; do [ "$(basename "$f")" = "_check" ] || cp -r "$f" "$DEST/parts/"; done
cp -r "$ROOT/src/assets" "$DEST/assets"
echo "복사함: out/$NAME/assets/shared (부품 + 글꼴 · 효과음 · 사진). 이 폴더는 고치지 않는다."
