# WSL

WSL에서 작업시 팁, 이슈를 기록

## 커맨드

```sh
# 현재 경로에서 vscode 실행
code .

# 현재 경로에서 윈도우 탐색기 실행
explorer.exe .

# 클립보드 복사 (기본 - 한글 깨질 수 있음)
clip.exe < 파일명.txt
ls | clip.exe

## 클립보드 복사 bashrc 단축어 등록 (한글 깨짐 방지 / 최초 1회 실행)
echo 'clip() { if [ -t 0 ]; then iconv -f UTF-8 -t UTF-16LE "\$1" | clip.exe; else iconv -f UTF-8 -t UTF-16LE | clip.exe; fi; }' >> ~/.bashrc && source ~/.bashrc

## 단축어 사용법
clip 파일명.txt
ls | clip
```
