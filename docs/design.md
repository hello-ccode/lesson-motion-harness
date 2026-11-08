---
name: 신문 다큐멘터리
colors:
  paper: "#e8e4db"
  paper-shade: "#c9c3b6"
  ink: "#1d1d1b"
  ink-soft: "#4a4844"
  ink-faint: "#8a867e"
  rule: "#c0322b"
  highlight: "#cdeb3a"
  on-photo: "#f4f1ea"
  tag: "#111111"
  on-tag: "#ffffff"
typography:
  serif: { family: "NotoSerifKR", file: "assets/fonts/NotoSerifKR-VF.woff2", weights: [400, 500, 900] }
  sans: { family: "Pretendard", files: ["assets/fonts/Pretendard-Regular.woff2", "assets/fonts/Pretendard-SemiBold.woff2", "assets/fonts/Pretendard-Bold.woff2"], weights: [400, 600, 700] }
  sizes: { masthead: 300, year: 220, title: 96, name: 72, lead: 56, body: 44, label: 32 }
spacing: { 16: 16, 24: 24, 32: 32, 48: 48, 64: 64, 96: 96, rule-thick: 14, rule-thin: 4, dot-gap: 14 }
components: [paper-ground, year-card, headline-page, portrait-clipping, clipping-note, stamp, label-tag]
---

# design.md — 신문 다큐멘터리 룩

> **이 문서에 있는 값만 쓴다.** 없는 값이 필요하면 지어내지 말고 "새 후보"로 묻는다.
> 출처: 레퍼런스 스틸 3장(인물 초상 · 헤드라인 · 연도, 상용 템플릿 미리보기). **스타일만 참고하고 화면은 코드로 새로 만들었다.** 템플릿 이미지 · 글자 · 사진은 영상에 넣지 않는다.
> 기준: 1920×1080 영상 px. 토큰 파일은 `src/parts/tokens.css`(값은 이 문서와 같다).

## 1. 색

| 이름 | 값 | 쓰는 곳 | 출처 |
|---|---|---|---|
| `paper` | `#e8e4db` | 신문지 바탕 | 레퍼런스 ①② 종이 밝은 부분 |
| `paper-shade` | `#c9c3b6` | 종이 그늘 · 접힌 자국 | 레퍼런스 ① 구김 그늘 |
| `ink` | `#1d1d1b` | 헤드라인 · 본문 · 사진 틀 | 레퍼런스 ② 헤드라인 |
| `ink-soft` | `#4a4844` | 사진 옆 이름 · 부제 · 쪽수 · 작은 설명 | 레퍼런스 ① 이름 글자 |
| `ink-faint` | `#8a867e` | **장식 전용** (십자표 등). 읽는 글자에 쓰지 않음 | 레퍼런스 ① 십자표 |
| `rule` | `#c0322b` | 빨간 줄 · 도장 · 머리말 | 레퍼런스 ② 빨간 줄 |
| `highlight` | `#cdeb3a` | 형광펜 (곱하기 섞기) | 레퍼런스 ② 형광펜 |
| `on-photo` | `#f4f1ea` | 사진 위 글자 | 레퍼런스 ③ 연도 글자 |
| `tag` / `on-tag` | `#111111` / `#ffffff` | 라벨 | 레퍼런스 ② 라벨 |

- 강조색은 **빨강(줄 · 도장)과 형광펜 두 가지뿐**이다. 한 장면에 형광펜은 한 군데.
- 화면은 흑백 + 종이색이 기본이다. 색 사진은 쓰지 않는다 (6장).
- 읽는 글자는 종이 위 명도 대비 3:1 이상 (`ink` · `ink-soft`만).

## 2. 글자

| 이름 | 글꼴 · 굵기 | 크기 | 쓰는 곳 |
|---|---|---|---|
| `masthead` | 명조 900 | 300 | 화면 위로 잘려 나가는 헤드라인 낱말 |
| `year` | 고딕(Pretendard) 700 | 220 | 연도 숫자 |
| `title` | 명조 500~900 | 96 | 연도 카드 부제 · 기사 조각 제목 |
| `name` | 명조 500 | 72 | 사진 옆 이름 |
| `lead` | 명조 400 기울임 | 56 | 형광펜 문장 (오른쪽 정렬) |
| `body` | 명조 400 | 44 | 정의 · 본문 |
| `label` | 고딕 700 또는 명조 400 | 32 | 라벨 · 쪽수 (**최소 크기**) |

- 명조: Noto Serif KR (OFL, 한글 2350자 + 라틴 · 기호만 남긴 가변 글꼴). 고딕: Pretendard (OFL).
- 숫자 연도와 라벨만 고딕, 나머지는 전부 명조.
- 32px보다 작은 글자는 없다 (뒤 신문 글자는 질감이라 예외).

## 3. 글꼴 불러오기

```css
@font-face { font-family: "NotoSerifKR"; font-weight: 200 900; src: url("assets/fonts/NotoSerifKR-VF.woff2") format("woff2"); }
@font-face { font-family: "Pretendard"; font-weight: 700; src: url("assets/fonts/Pretendard-Bold.woff2") format("woff2"); }
```

## 4. 크기

| 이름 | 값 | 쓰는 곳 |
|---|---|---|
| `rule-thick` | 14 | 헤드라인 아래 빨간 줄 |
| `rule-thin` | 4 | 짧은 검정 줄 · 기사 조각 이중선 |
| `dot-gap` | 14 | 이름 아래 점선 간격 (점 지름 5) |
| 간격 | 16 · 24 · 32 · 48 · 64 · 96 | 여백 |

## 5. 질감 (모든 장면 공통)

| 층 | 파일 | 세기 | 만드는 법 |
|---|---|---|---|
| 종이 | `assets/textures/paper.jpg` (2400×1350) | 그대로 | 코드로 생성 (seed 1869) |
| 뒤 신문 글자 | `assets/textures/newsprint.png` | 투명도 0.32 · 흐림 2.5px · 곱하기 | 코드로 생성 (채움글, 사실 주장 없음) |
| 비네트 | CSS radial-gradient | 가장자리 0.35 | paper-ground 부품 |
| 필름 그레인 | `assets/textures/grain.png` (512 타일) | 투명도 0.35 · overlay | 영상 전체에 한 장 |

## 6. 사진

- **흑백(회색조)만.** 넣기 전에 흑백으로 바꾼다 (`npx hyperframes media-treatment` 또는 이미지 편집).
- **자유 이용 사진만** (위키미디어 공용 등 퍼블릭 도메인 · CC). 출처를 `src/assets/photos/SOURCES.md`에 적는다.
- **인물 사진을 실존 인물 얼굴로 꾸미지 않는다.** 인물 초상 틀에는 사물 · 장소 · 표본 · 문서 사진을 우선 쓴다.
- 연도 카드 사진은 **왼쪽 40%가 비어 있는(하늘 · 벽 · 바탕) 사진**을 고른다. 글자가 그 자리에 들어간다.
- 데모용 사진(`sample-*.png`)은 코드로 짠 판화다. 실제 수업에서는 바꿔 넣는다.

## 7. 부품 목록

| 부품 | 레퍼런스 | 크기 | 바꾸는 부분 | 미리보기 |
|---|---|---|---|---|
| `paper-ground` | 공통 바탕 | 2400×1350 | 뒤 신문 글자 위치 | `_check/paper-ground.jpg` |
| `year-card` | ③ 연도 | 1920×1080 | 사진 · 연도 · 부제 · 메모 | `_check/year-card.jpg` |
| `headline-page` | ② 헤드라인 | 1920×1080 | 헤드라인 낱말 · 두 줄 문장 · 형광펜 자리 · 라벨 | `_check/headline-page.jpg` |
| `portrait-clipping` | ① 인물 초상 | 1600×760 | 사진 · 이름 · 한 줄 설명 | `_check/portrait-clipping.jpg` |
| `clipping-note` | ②의 응용 | 폭 1100 | 머리말 · 용어 · 정의 · 쪽수 · 형광펜 자리 | `_check/clipping-note.jpg` |
| `stamp` | 이전 사이클 "반박!" 도장 | 글자에 맞춤 | 글자 2~6자 | `_check/stamp.jpg` |
| `label-tag` | ② 라벨 | 높이 58 | 글자 한 줄 | `_check/label-tag.jpg` |

부품마다 파일 맨 위 주석에 **바꾸는 부분 · 건드리지 않는 것 · 따로 움직일 수 있는 조각(id)**이 적혀 있다.

## 하지 말 것

- 둥근 카드 · 그림자 많은 UI 상자 · 아이콘 원 (신문 룩이 아니다)
- 그라데이션 배경, 색 사진, 네온 · 글로우
- 형광펜 두 군데 이상, 빨강을 글자 색으로 넓게 쓰기
- 템플릿 이미지를 그대로 쓰거나 템플릿 글자를 따라 쓰기
