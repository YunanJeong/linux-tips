# wsl-service

## init, systemd 공통

- Linux 시스템이 시작될 때 같이 시작되는 프로세스
- 정상 부팅을 위한 초기화 작업 및 전체 시스템 관리에 이용된다.
- 역할이 비슷하므로, 대부분 Linux에서 둘 중 하나만 채택하여 사용된다.
- 모든 프로세스의 부모 프로세스(parent process)다.

## init

- 과거 시스템
- `service` 명령어로 서비스를 관리
  - e.g. status 정보 확인시, 현재 동작 유무 등 매우 간소한 정보만 출력해준다.

  ```sh
  # 명령어 예시
  sudo service docker start
  sudo service docker status
  ```

- WSL은 init을 기본적으로 지원한다.

## systemd

- 최신 시스템. 최근 대부분 Linux 배포판들은 systemd 사용
- init프로세스의 기능 포함 + 성능향상 + 기능 추가
- `systemctl` 명령어로 서비스를 관리
  - e.g. status 정보 확인시, 동작시간 등 상세정보를 출력해준다.

  ```sh
  # 명령어 예시
  sudo systemctl start docker.service
  sudo systemctl status docker.service
  ```

## WSL systemd 활성화

- [Windows11, WSL 0.67.6 이상 환경에서 systemd 공식지원](https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/)

- Windows 10도 WSL 업데이트 후 가능

  ```powershell
  # Powershell에서 wsl 업데이트
  wsl --update
  ```

- 활성화 방법
  - WSL에서 `$ sudo vi /etc/wsl.conf`으로 다음 내용 추가

    ```conf
    [boot]
    systemd=true
    ```

  - PowerShell에서 `> wsl --shutdown` 후 WSL 재실행

- 이하 사양에서는 오픈소스 프로젝트 [genie](https://github.com/arkane-systems/genie)를 설치하여 systemd 활성화 가능
  - 편하긴 한데 업데이트 및 호환성에 취약하므로 주의
  - genie는 다음과 같이 끄거나 켤 수 있다.

  ```sh
  # Powershell 관리자 권한에서,
  > wsl --shutdown         # wsl 종료 상태로,
  > wsl genie -s           # 켜기
  > wsl genie --shutdown   # 끄기
  ```

## systemd 활성화 후 `code .` 커맨드 사용이 불가능한 이슈

이 이슈는 Ubuntu, wsl, vscode 버전이 바뀔 때마다 종종 발생한다.

git issue에 원인/해결 스레드가 많은데, 추천수 많은 것 위주로 찾아보면 어지간하면 해결된다.

### Case 1. genie가 이미 설치되어있어 충돌

- `$ sudo apt remove systemd-genie`로 삭제 후 WSL을 재실행
- 문제 지속시, `/etc/wsl.conf`삭제, WSL재실행으로 systemd를 끌 수 있다. 이후 `code .` 사용이 가능하다.

### Case 2. systemd 활성화시 exe 파일 link에 문제발생

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
