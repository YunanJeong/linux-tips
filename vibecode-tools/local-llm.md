# Local LLM Environment Guide (Ollama)

## Ollama

- ollama기업에서 만든 오픈소스
- llm 배포 & 활용에 사실상 표준으로 쓰이는 도구
- VRAM이 최중요사항, 부족시 공유메모리(RAM)쓰는데 속도저하

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