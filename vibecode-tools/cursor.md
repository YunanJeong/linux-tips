# cursor (2026.02.24.)

- IDE
  - vscode를 fork해서 만들어서 대부분 extension 호환됨
  - 로컬 vscode가 있다면, extension 창에서 기존 것들을 일괄 가져오는 기능이 있음
  - 단순 Editor로 쓰려고해도, 로그인을 필수요구함
- WSL에서
  - vscode처럼 로컬 윈도우에 설치
  - WSL 내부에서 `cursor .`로 실행가능
  - cursor 전용 WSL extension은 IDE에 기본 포함
- github copilot과 기능적으로 비슷함
  - 인라인 대화 및 생성(`Ctrl+K`)
  - 우측 채팅창 통하여 대화 및 생성(`Ctrl+L`)
    - 우측 채팅창에서 모드 변경 (`shift+tab`)
    - Ask/Plan, Agent, Debug 순으로 특화된 모드 사용시 효율적
    - Ask/Plan은 파일을 건드리지 않음
- gemini-cli, codex-cli 같은 CLI와 달리, 코드 편집·리뷰·리팩토링을 전부 에디터 안에서 끝내는 용도로 쓰게 된다.

## 요금체계&모델 선택

## 보안