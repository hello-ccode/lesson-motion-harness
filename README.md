# 수업 모션 하네스 (lesson-motion-harness)

교과서나 직접 만든 수업 자료의 한 소단원을 **교실 TV로 보는 중학생 수업 영상**으로 만드는 작업 틀(하네스)입니다.
[노션톡 챌린지](https://github.com/scieum/notiontalk_cycle_harness) 2주차 시작 저장소에서 출발해, 방과후 경제교육 "복리" 수업에 맞게 지었습니다.

- 룩: 크림 종이 콜라주(찢은 종이 가장자리 · 망점 · 짙은 남색 글자 · 빨간 손그림 동그라미)
- 움직임: Vox 설명 영상을 프레임 단위로 재서 정한 값
- 화면 규칙: 교실 맨 뒷자리에서도 읽히는 글자 크기 · 한 화면 글자 적게
- 소리: 슈퍼토닉 TTS 내레이션 + FFmpeg 효과음, loudnorm −16 LUFS

## 어떻게 쓰나
Claude 데스크톱 앱(Code 탭)에서 이 폴더를 열고 **"수업 영상 만들자"** 한 줄로 시작합니다.
`.claude/skills/make-video`가 아래 순서로 에이전트 5명을 부릅니다. ✋는 사람이 승인해야 다음으로 갑니다.

브리프 → 수업 자료 정리 ✋ → 레퍼런스 → 장면표 ✋ → 스냅보드 ✋ → 생성 · 검수 → 렌더 → 규칙 남기기

| 에이전트 | 하는 일 |
|---|---|
| `content-editor` | `docs/textbook/`에서 이번 영상에 넣을 문장만 쪽수와 함께 고른다 |
| `art-director` | 룩 · 움직임 문서에서 쓸 부품과 토큰을 고르고 없는 것을 찾는다 |
| `director` | 장면표와 내레이션 대본을 짠다(숫자는 소리 나는 대로) |
| `builder` | HyperFrames로 영상을 만든다. 그림이 필요하면 직접 그리지 않고 목록을 적고 멈춘다 |
| `critic` | 렌더한 영상을 판정만 하고 `gates.md`에 적는다. 고치지 않는다 |

규칙 3개(`CLAUDE.md`): 내용은 `docs/textbook/`에서만 · 값은 `docs/`와 `src/parts/`에서만 · 사람 승인 뒤에 만들고 critic이 판정.

## 폴더
| 폴더 | 내용 |
|---|---|
| `CLAUDE.md` · `.claude/` | 하네스 지침, 에이전트 5명, `make-video` 스킬 |
| `docs/design.md` | 룩 · 색 · 글자 · 부품 목록 (값마다 출처) |
| `docs/motion.md` | 움직임 · 머무는 시간 · 카메라 (Vox 영상에서 잰 값) |
| `docs/video.md` | 화면 규칙(글자 최소 크기, 배경, 표기, 부품) |
| `docs/sound.md` · `docs/check.md` | 소리 기준, 렌더 뒤 점검 기준 |
| `src/parts/` | 부품 10개 + `tokens.css` + 견본 사진(`_check/`) |
| `src/assets/` | 글꼴, 효과음 4개, 그림(`photos/`) |
| `scripts/` | 내레이션 · 효과음 만들기, 부품 복사, 렌더 뒤 재기 |
| `templates/look/` | 룩 빈 양식(시작 저장소에서 받은 것) |

## 올라가지 않는 것
- 수업 자료 원문 변환본(`docs/textbook/*.md`, 목차 · 형식 · 예시만 올림), 영상 결과물(`out/`), 레퍼런스 원본(`references/`)
- HyperFrames 등 외부 스킬 설치본: `npx skills add heygen-com/hyperframes`로 다시 받습니다(`skills-lock.json`).
- 내 컴퓨터 경로 · 설정(`CLAUDE.local.md`)

## 준비물
Claude 데스크톱 앱(Pro 이상), Node.js 22 이상, FFmpeg, (내레이션용) Supertonic TTS. 슈퍼토닉 위치는 `CLAUDE.local.md`에 적습니다(저장소에 올리지 않는 파일).

## 지금 상태
시험 영상 한 편(슬라이드14 단리 · 복리 비교, 25초)으로 하네스가 끝까지 도는 것을 확인했습니다. 룩과 움직임을 레퍼런스에 더 가깝게 하려면 그림(시계 · 동전 등)과 인트로 장면이 더 필요합니다.
