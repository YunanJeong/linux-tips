# Cursor (2026.02)

## 개요
- VS Code 기반 IDE
  - VS Code를 fork하여 개발됨
  - vscode extension이 대부분 호환되며, 로컬에 기존 vscode가 있다면 기존 extension 및 설정을 그대로 가져오기도 지원함
- WSL에서 활용시
  - vscode처럼 호스트 윈도우에 설치 후 WSL내부에서 `cursor .` 로 실행 가능
  - WSL 연동을 위한 전용 WSL-extension은 cursor설치시 기본 포함됨
- 최근 버전은 에디터로만 쓰려고 해도 로그인 필수
- 왜 쓰는가?
  - 전반적으로 github copilot과 비슷한 느낌의 서비스를 제공하는데, extension만으로는 구현이 힘든 부분이 있어 AI활용 목적으로 만들어진 IDE가 cursor임
  - 기존 vscode extension은 현재 작업 파일, 최근 파일 정도만 권한을 가지는데, `Cursor는 프로젝트 전체, 멀티파일에 대한 권한을 가지고 맥락을 파악함`
  - CLI 도구들과 달리 에디터 내에서 완결된 워크플로우를 제공
  - 유명 타사 모델 제휴 등

## 주요 AI 기능

- `Cursor Tab` (Tab Completion, 탭키로 자동완성)
  - 전용 모델 기반의 실시간 코드 예측 및 제안
  - 하단바 우측에서 제어 가능(활성화 여부/모델선택 등)
- `Ctrl+K`
  - 인라인 Quick Chat 열기
  - 인라인 채팅 후 부분 편집 가능
- `Ctrl+I or Ctrl+L`
  - 사이드 Chat 패널 열기 (과거 Composer, Edit, Chat 등으로 불렸으나 통합됨)
  - Ask/Plan/Agent/Debug 모드 중 선택 (shift+tab으로 전환)
  - `Ask/Plan은 코드 수정하지 않음`
  - `Agent/Debug은 프로젝트 내 전권을 가지고 파일을 생성/편집/삭제가능하며 터미널 실행/테스트실행 배포/환경구축도 가능`
- 사용량 체크
  - 웹설정(https://cursor.com/dashboard)의 Usage 항목

## 요금제 및 BYOK (Bring Your Own Key)
- Free (구 Hobby)
  - 카드 등록 없이 사용 가능하나 Pro 모델 및 기능 사용 횟수 제한.
  - 공식 한도는 비공개이나, 블로그 등에서 2000회, Premium Requests는 50회로 추정(2026.02.25.)
  - 저사양 cursor 모델 사용
- `Pro (Cursor쓸 때 사실상 정석)`
  - 월 $20. 고성능 모델 및 모든 AI 기능 무제한(또는 높은 한도) 제공.
  - 전체 프로젝트 파일에 대한 파악, 큰 규모의 Context 처리에 훨씬 우월하다고 함
- `BYOK (개인 API 키) 사용가능하지만 비권장`
  - 단순 Chat 및 일부 Edit 기능에만 적용 가능.
  - Cursor Tab, Agent 등 고급 기능은 BYOK로 사용 불가 (Cursor 전용 인프라와 모델 결합이 필수적이기 때문).
  - 핵심 기능을 온전히 쓰려면 Pro 플랜 구독이 권장됨
- Free/Pro 상관없이 타사모델 사용가능
  - 기본 제휴된 타사모델은 Cursor자체모델과 결합하여 Cursor고유기능 제공에 활용됨
  - BYOK로 가져오는 타사모델은 단순 채팅 등에만 적용되며, 이 때 Cursor고유기능 활용시 Cursor자체모델로만 실행됨 (사용하는 구독 플랜 수준으로 실행됨)
  
## 보안 및 개인정보
- Privacy Mode: 웹 설정에서 활성화 시 사용자 코드가 학습에 사용되지 않음.
  - default 활성화되어있지만 꼭 체크하도록 하자
- 유/무료 플랜 관계없이 설정 가능