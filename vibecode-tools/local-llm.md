# Local LLM Environment Guide (Ollama)

## Ollama

- ollama기업에서 만든 오픈소스
- llm 배포 & 활용에 사실상 표준으로 쓰이는 도구
  - 도커같은 느낌
  - 레지스트리에 허깅페이스의 주요모델도 다 올라오긴 함. 없어도 연동 방법 있음.
- VRAM이 최중요사항, 부족시 공유메모리(RAM)쓰는데 속도저하
- 클로드코드, 코덱스cli 등 네임드툴은 ollama에서 바로 연결해버릴 수 있음 

```md
# 회사컴
- GPU: RTX4080(VRAM:16GB)
- RAM: 64GB
- 가용 모델 규모: 14~32B (Billions, 파라미터 수)

# 집컴
- GPU: RTX3070(VRAM:8GB)
- RAM: 32GB
- 가용 모델 규모: 8B

# AWS g6.xlarge
- GPU: NVIDIA L4 Tensor Core GPU(VRAM:24GB)
- RAM: 16GB
- 가용 모델 규모: 32~70B
- 비용주의: 스팟 인스턴스 및 awscli로 start-stop 방식 활용 (코어타임 활성 자동화?)
- 테라폼으로 보안그룹 + nginx 기본auth 정도 세팅하면 될듯?
- 다수 접속시 속도저하
  - ollama에서 Concurrency설정 필요, VRAM 점유 증가
  - 현 조건에서 1~5명까진 쓸 수 있을 듯
```

## WSL에서

- 모델 실행도 WSL내부에서 한다. (윈도우 호스트에 설치시 오히려 이슈가 더 클 수 있음)
- 어차피 cpu, gpu 가 중요한데, WSL쪽에서 그대로 쓸 수 있으니 상관 없음.
- RAM의 경우 wslconfig에 따라 부족할 수 있으나 이미 VRAM 초과해서 RAM 쪽을 쓰는 상황이라면 성능저하가 심해서 사용하기 애매함
- 윈도우 호스트 쪽에 NIVIDA Driver만 미리 설치해두면됨.(옛날 tensorflow, pytorch 쓸 때 처럼 Cuda 등등 잡다하게 설치 안해도 됨)

## 기본조작

```sh
# 통합 메뉴로 진입하여 조작하기
ollama

# 설치된 모델 목록 및 용량 확인
ollama list

# 모델 다운로드 (파일만 미리 받기)
ollama pull <model_name>

# 모델 실행 및 대화 세션 진입 (없으면 다운로드 후 실행)
ollama run <model_name>

# LLM대화 세션 (대화창 내부)에서 사용
/bye             # 대화세션 나가기(Ctrl+D) # 모델은 여전히 VRAM 점유함
/show info       # 모델 상세 정보 확인
/set verbose     # 응답 속도/통계 표시

# 현재 메모리(VRAM)에 로드된 모델 확인
ollama ps

# 특정 모델을 메모리에서 즉시 내리기 (VRAM 해제)
ollama stop <model_name>

# 모델 파일 삭제
ollama rm <model_name>

# ollama 서비스 관리 (Linux)
sudo systemctl status ollama
sudo systemctl restart ollama

# 서비스 종료 (Windows)
# 작업 표시줄 트레이 아이콘 우클릭 -> Quit Ollama 클릭
```