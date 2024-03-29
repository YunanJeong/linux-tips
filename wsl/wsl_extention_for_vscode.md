# vscode에서 wsl extension

wsl에서 `code .`로 vscode 실행시 wsl extension 설치권장알림이 뜨는데, 꼭 설치하도록 한다. 설치하지 않더라도 사용가능하지만, wsl과 vscode 간 호환문제가 발생한다.

wsl extension은 다음과 같은 기능을 지원한다.

## 1. vscode 자체에서 서브윈도우로 wsl 터미널을 열기

## 2. vscode extension 설치환경을 local(winodws)과 remote(wsl)로 격리하여 관리

- 귀찮을 수 있는데, 원래 WSL이 Linux 환경 격리를 목적으로 하기때문에 꼭 필요하다.

- 디버깅, 테스트, 빌드, 실행 기능 등이 포함된 extension은 WSL환경에 의존해야하는 데, local에만 설치된 경우 비정상동작하거나 매우 느리다.

- lint, intellisense 등도 반드시 따로 설치해야한다. (e.g. 빨간 줄이 안뜨거나 반응속도가 느릴 수 있음)

- extension에 따라 local 전용, 또는 wsl 전용일 수 있음
  - local에만 설치해도 전체적용될 때가 있는데, 이는 vscode editor에만 적용되어도 수행가능한 extension이라 그렇다. (e.g. blockman, 테마 설정 등)
  - 이런 것들은 extension 목록에 커서를 갖다대면 `전역적`으로 설정되었다는 알림을 확인가능하고, remote환경에 별도설치를 할 필요없다.

## 3. WSL에서 `code .` 커맨드 오동작 방지

- wsl extension 설치안하면 vscode 창이 꺼질 때까지 터미널 점유함
- `code . &`으로 실행하거나, wsl extension을 설치하면 해결

## 4 systemd 활성화시 exe 파일 link에 문제발생

- 문제

```sh
$ code .
/mnt/c/Users/USER/AppData/Local/Programs/Microsoft VS Code/bin/code: 61: /mnt/c/Users/USER/AppData/Local/Programs/Microsoft VS Code/Code.exe: Exec format error
```

- 해결방법: 다음 명령어 수행([git이슈](https://github.com/microsoft/WSL/issues/8952))

```sh
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
sudo systemctl unmask systemd-binfmt.service
sudo systemctl restart systemd-binfmt
sudo systemctl mask systemd-binfmt.service
```
