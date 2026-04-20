# claude-code (2026.02.26.)

- Anthropic사에서 제공하는 코딩 에이전트 서비스를 통칭
- CLI, VSCode extension, 데탑앱, 웹, 제트브레인 등 다방면을 지원하지만,
- claude code라고 하면 사실상 cli툴을 가리킴

## 비용

- 무료 플랜 없음
- 채팅 서비스 구독 요금 공유 or API 종량제 사용
- 동급 20달러 대의 타사 구독 플랜과 비교시, 요청가능 한도가 낮으나 코딩 성능은 좋다고 평가받는 편

## 보안

- 개인용(Pro, Max): 기본적으로 대화 및 코딩 세션이 모델 학습에 사용될 수 있음. 단, 설정에서 '학습 허용'을 끄면 제외됨
- 비즈니스/API용: 제출된 코드나 프롬프트는 절대 모델 학습에 사용하지 않음 (Zero Data Training)
- 보관 기간: 학습 비허용 시 30일 후 삭제. 피드백(좋아요/싫어요) 제출 시 최대 5년 보관
- 작업 디렉토리에 `.claudeignore`를 생성하여 민감정보가 담긴 파일을 읽지 않도록 제외 가능


## 기타

기존 인증해제, 환경변수 등록 후 재시작으로 로컬 LLM 적용 가능

### `/model`에 안 뜨는 모델 사용하기 (Bedrock 기준)

Bedrock 연동으로 Claude Code를 쓸 때 `/model` 목록에는 기본 후보만 뜨고, 신규/구버전 모델은 누락되는 경우가 많다. 이땐 Bedrock 모델 ID를 직접 지정하면 된다.

**방법** — 환경변수 또는 설정 파일에 Bedrock 모델 ID를 지정:

```bash
# 환경변수 방식 (재시작 필요)
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-west-2
export ANTHROPIC_MODEL="us.anthropic.claude-opus-4-7-v1:0"
```

또는 `~/.claude/settings.json`에:

```json
{
  "env": {
    "CLAUDE_CODE_USE_BEDROCK": "1",
    "ANTHROPIC_MODEL": "us.anthropic.claude-opus-4-7-v1:0"
  }
}
```

**정확한 Bedrock 모델 ID 찾는 법** — Bedrock ID는 `provider.model-name-version:revision` 형식이고, 리전별 inference profile은 앞에 `us.` / `eu.` / `apac.` 같은 접두사가 붙는다. 표시명이 아니라 이 ID 문자열을 정확히 넣어야 동작한다.

1. **AWS 콘솔**: Bedrock → "Model access" / "Model catalog"에서 활성화된 모델의 ID 확인 (가장 확실)
2. **AWS CLI**:
   ```bash
   aws bedrock list-foundation-models --region ap-northeast-2 \
     --query "modelSummaries[?contains(modelId, 'claude')].modelId"
   aws bedrock list-inference-profiles --region ap-northeast-2 \
     --query "inferenceProfileSummaries[].inferenceProfileId"
   ```
   계정에서 실제 호출 가능한 ID만 나오므로 오타/권한 문제를 동시에 걸러낼 수 있다
3. **Anthropic 공식 문서** "Models overview"의 Bedrock ID 표 참조
4. **cross-region inference**가 필요한 최신 모델은 foundation model ID가 아닌 **inference profile ID**(접두사 `us.` 등)를 써야 하는 경우가 많음 — 호출 실패 시 profile ID로 바꿔 시도

## 설정 파일 위치

Claude 관련 설정/데이터는 주로 `.claude/` 아래 모이지만 일부는 바깥에도 있다.

```
~/                                  # 유저 전역
├── .claude/
│   ├── settings.json               # 전역 설정(모델, 퍼미션, 훅 등)
│   ├── CLAUDE.md                   # 전역 지침(모든 프로젝트에 적용)
│   ├── keybindings.json            # 단축키 커스터마이징
│   ├── agents/                     # 사용자 정의 서브에이전트
│   ├── commands/                   # 사용자 정의 슬래시 커맨드
│   ├── projects/                   # 프로젝트별 세션/메모리 저장소
│   └── todos/                      # 세션 간 공유되는 할일 상태
├── .claude.json                    # 사용자 상태/설정 파일 (디렉토리 아님)
└── CLAUDE.md                       # 홈에 두면 전역 지침으로 사용 가능

<repo>/                             # 프로젝트별
├── .claude/
│   ├── settings.json               # 팀 공유용 프로젝트 설정 (커밋 대상)
│   ├── settings.local.json         # 개인용 로컬 설정 (git ignore 대상)
│   ├── agents/                     # 프로젝트 전용 서브에이전트
│   └── commands/                   # 프로젝트 전용 슬래시 커맨드
├── CLAUDE.md                       # 프로젝트 지침 (아키텍처, 컨벤션 등)
└── .mcp.json                       # MCP 서버 설정 (프로젝트 루트 직접 배치)
```

### git 제외 규칙

- `.claude/settings.local.json`은 git의 **글로벌 ignore** 경로인 `~/.config/git/ignore`에 `**/.claude/settings.local.json` 패턴으로 공통 등록된다
- 즉 저장소별 `.gitignore`에 따로 써주지 않아도 모든 리포에서 자동으로 커밋 대상에서 제외됨
- 반대로 `.claude/settings.json`(팀 공유용)이나 `CLAUDE.md`는 커밋 대상으로 둬도 무방