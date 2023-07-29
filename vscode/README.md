# Vscode

# 유용한 extension
- wsl: vscode에 설치가능한 wsl을 위한 extension이다. wsl에서 `code . `로 vscode 실행시 wsl extention 설치권장알림이 뜨는데, 꼭 설치하도록 한다.
- blockman: indent에 따라 코드전체를 박스쳐서 잘 보이게 해줌


# wsl extention의 역할
텍스트 편집만 vscode에서 하고, 빌드 및 실행은 WSL터미널에서 하면 wsl extention 없이도 작업은 가능하지만 여러모로 불편한 점이 많다. wsl extension은 다음과 같은 기능을 지원한다.

### 1. vscode 자체에서 서브윈도우로 wsl 터미널을 열기

### 2. vscode extension 설치환경을 local(winodws)과 remote(wsl)로 격리하여 관리
귀찮을 수 있는데, 원래 WSL이 Linux 환경 격리를 목적으로 하기때문에 꼭 필요하다.

- 디버깅, 테스트, 빌드, 실행 등의 기능들이 포함된 extension은 WSL환경에 의존해야하는 데, local에만 설치된 경우 비정상동작하거나 매우 느리다. 

- lint, intellisense 등도 반드시 따로 설치해야한다. (e.g. 빨간 줄이 안뜨거나 반응속도가 느릴 수 있음)

- extension에 따라 local 전용, 또는 wsl 전용일 수 있음
    - local에만 설치해도 전체적용될 때가 있는데, 이는 vscode editor에만 적용되어도 수행가능한 extension이라 그렇다. (e.g. blockman, 테마 설정 등)
    - 이런 것들은 extension 목록에 커서를 갖다대면 `전역적`으로 설정되었다는 알림을 확인가능하고, remote환경에 별도설치를 할 필요없다.

### 3. WSL에서 `code . ` 커맨드 오동작 방지
    - wsl extension 설치안하면 vscode 창이 꺼질 때까지 터미널 점유함
    - `code . &`으로 실행하거나, wsl extension을 설치하면 해결

