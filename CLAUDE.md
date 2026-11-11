# CLAUDE.md · 수업 영상 하네스

## 목적
교과서(또는 선생님이 만든 수업 자료) 한 소단원을 **교실 TV로 보는 중학생 수업 영상**으로 만든다. 룩과 움직임은 선생님이 고른 레퍼런스(`docs/design.md` · `docs/motion.md`)를 따르고, 내용은 `docs/textbook/` 에 있는 것만 쓴다.
영상 한 편은 `out/<영상이름>/` 폴더 하나이다. 시작은 선생님의 한 줄 "수업 영상 만들자" → `.claude/skills/make-video` 를 따른다.

## 규칙 3개
1. **내용은 `docs/textbook/` 에서만, 쪽수와 함께.** 화면 글 · 숫자 · 단위 · 대본의 내용은 변환본의 `[p.…]` 문장에서 온다. 자료에 없는 내용은 쓰지 않고 선생님께 묻는다. 새 문장을 지어 채우지 않는다.
2. **값은 `docs/` 와 `src/parts/` 에서만.** 색 · 크기 · 자리 · 시간 · 곡선 · 소리 값은 `docs/design.md` · `motion.md` · `video.md` · `sound.md` · `check.md` 와 `src/parts/tokens.css` · 부품에 있는 것만 쓴다. **문서에 없는 값은 지어내지 말고 묻는다**(무엇이 · 왜 필요한지 · 기본값 후보 한 줄, 묶어서). 레퍼런스에서는 느낌(색 계열 · 글자 성격 · 구도 · 카메라 · 전환 · 박자)만 가져오고 사진 · 글자 · 로고 · 음악 원본은 가져오지 않는다.
3. **사람 승인 뒤에 만들고, critic이 판정한다.** 수업 자료 정리 · 장면표 · 스냅보드는 선생님 승인(✋) 뒤에 다음 단계로 간다. 만든 것은 `critic` 이 `docs/check.md` 기준으로 **판정만** 하고(고치지 않는다) 고치는 일은 `builder` 가 한다.

## 폴더
| 폴더 | 내용 |
|---|---|
| `docs/textbook/` | 수업 자료 변환본(`_format.md` 형식, 목차 `index.md`). **원문은 공개 저장소에 올리지 않는다** |
| `docs/design.md` · `motion.md` · `video.md` · `sound.md` · `check.md` | 룩 · 움직임 · 화면 규칙 · 소리 · 렌더 뒤 점검. 모든 값의 출처 |
| `src/parts/` | 부품 10개(`bg-paper` 등. 7개 + `rules-note` · `end-card` · `assume-tag`) + `tokens.css` · `paper-kit.js` · 견본 사진 `_check/` |
| `src/assets/` | `fonts/`(글꼴) · `sfx/`(효과음 4개, `scripts/make-sfx.sh` 가 만듦) · `photos/`(그림 · `SOURCES.md`) |
| `references/` | 레퍼런스 분석 문서와 이미지. **원본 영상 · 이미지는 올라가지 않는다**(`.gitignore`) |
| `templates/look/` | 룩 빈 양식 |
| `scripts/` | `make-voice.py`(내레이션) · `make-sfx.sh`(효과음) · `sync-parts.sh`(부품 복사) · `check-render.sh`(렌더 뒤 재기) |
| `out/<영상이름>/` | 영상 한 편(산출물 · 프로젝트 · 렌더). **올라가지 않는다** |
| `.claude/agents/` | `content-editor` · `art-director` · `director` · `builder` · `critic` |
| `.claude/skills/make-video/` | 영상 한 편 만드는 순서 |
| `.claude/skills/hyperframes*` 외 | HyperFrames 설치본(`npx skills add heygen-com/hyperframes`). 고치지 않는다 |

## 고정 · 참조 · 금지
**고정** (선생님이 말씀할 때 메인 대화에서만 바꾼다. 에이전트는 고치지 않는다)
- `docs/design.md` · `motion.md` · `video.md` · `sound.md` · `check.md`
- `src/parts/` 전체 · `src/assets/fonts/` · `src/assets/sfx/`
- `CLAUDE.md` · `.claude/agents/` · `.claude/skills/make-video/`
- 소리 설정: Supertonic F1 · 빠르기 1.05 · loudnorm `I=-16:TP=-1.5:LRA=11` (`docs/sound.md`)

**참조** (읽기만)
- `docs/textbook/*.md`(내용) · `references/`(느낌) · `templates/` · `.claude/skills/hyperframes*`(HyperFrames 사용법) · `CLAUDE.local.md`(내 컴퓨터 설정, 올라가지 않는 파일)

**금지**
- 수업 자료에 없는 내용 · 숫자 · 문장 쓰기, 쉬운 말로 바꿔 쓰기
- 문서에 없는 값 · 부품 쓰기(필요하면 만들지 말고 묻는다)
- 레퍼런스의 사진 · 글자 · 로고 · 음악을 가져오기 / 교과서 · 수업 자료 그림을 그대로 넣기
- **builder 가 시계 · 동전 같은 그림을 직접 그리거나 생성하기.** 그림이 필요하면 `out/<영상이름>/그림-필요-목록.md` 를 쓰고 **멈춘다.** 그림은 선생님이 agy나 코덱스로 만들어 `src/assets/photos/` 에 넣는다
- critic 이 고치기(판정만 한다) / 승인(✋) 없이 다음 단계로 가기
- 외부 음원 · 배경음악(필요하면 Openverse CC0만, `credits.txt` 에 적기)
- 학생 · 참가자 이름 등 개인 정보, 키 · 토큰 · `.env*`, **내 컴퓨터 경로**를 저장소 파일에 적기. 경로는 `CLAUDE.local.md` 에만 둔다
- `docs/textbook/` 변환본 · `out/` · 레퍼런스 원본을 GitHub에 올리기. 저장소를 만들거나 올리기 전에는 반드시 선생님께 먼저 묻는다

## 작업 순서
`make-video` 스킬이 자세히 적고 있다. 줄거리:

1. **브리프** — 영상 이름 · 범위 · 학습 목표
2. **수업 자료 정리** (`content-editor`) ✋
3. **레퍼런스** (`art-director`) — 쓸 부품 · 토큰 · **없는 것** 찾기
4. **장면표** (`director`) ✋ — 화면 글(쪽수) · 대본 · 머무는 종류
5. **스냅보드** (`builder`) ✋ — 그림이 없으면 목록을 쓰고 멈춤
6. **생성 · 검수** (`builder` → `critic`) — 내레이션 · 효과음 · 장면, 불통과만 고침
7. **렌더** (`builder` → `critic`) — loudnorm, 정지 · 무음 · 음량 · 밝기 판정, 선생님 시청
8. **규칙 남기기** — 고친 것을 `docs/` 에 출처와 함께 적기 ("이번 장면만 예외 / 다음에도 쓸 기본값" 한 줄)

## 1주차에 해 보고 정한 것 (출처: 1주차 `motion.md` 0절 · 4절 · 6절)
- 내레이션은 Supertonic F1 · 빠르기 1.05. 숫자 · 약자는 **소리 나는 대로** 대본에 적는다(112 → 일일이). 한 곳 설명에 한 문장, 표시는 문장 끝에. **장면 길이는 내레이션에 맞춘다**(말 속도를 바꾸지 않는다). → `docs/sound.md`
- 효과음은 FFmpeg로 합성한 pop · tick · marker · chime 네 가지만. 렌더 뒤 `loudnorm=I=-16:TP=-1.5:LRA=11`. → `docs/sound.md`
- 렌더 뒤 `freezedetect=n=-80dB:d=3` · `silencedetect=noise=-40dB:d=1.5` 를 돌려 **읽을 시간 · 생각할 시간 · 마지막 2초가 아닌 곳**은 불통과로 `gates.md` 에 적는다. → `docs/check.md`
- 영상에서 고친 것은 같은 대화 안에서 해당 `docs/` 문서에도 고친다. → `make-video` 마지막 단계

## 내 컴퓨터 설정
Supertonic 위치 같은 **내 컴퓨터에만 있는 값**은 `CLAUDE.local.md`(올라가지 않는 파일)에 있다. 없으면 만들어 달라고 선생님께 부탁한다. 이 저장소의 어떤 파일에도 내 컴퓨터 경로를 적지 않는다.
