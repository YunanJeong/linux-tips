# Vscode

# 유용한 extension
- blockman: indent에 따라 코드전체를 박스쳐서 잘 보이게 해줌


# wsl extention 관련
- wsl에서 첫 실행시 설치권장 알림 뜸
- 설치하면 이후 extension은 local 환경과 wsl 환경이 분리돼서 설치됨
    - [extension 굳이 분리시키는 이유](https://www.bettercoder.io/job-interview-questions/2250/what-is-the-advantage-of-visual-studio-code-remote-wsl-extension)
    - extension에 따라 local 전용, wsl 전용이 존재할 수 있음
    - local에 설치해도 전체적용되는 경우가 있는데, extension 목록에 커서를 갖다대면 `전역적`으로 설정되었다는 알림 확인가능

- `code . ` 커맨드 관련
    - wsl extension 설치안하면 vscode 창이 꺼질 때 까지 터미널 점유함
    - `code . &`로 해결가능

