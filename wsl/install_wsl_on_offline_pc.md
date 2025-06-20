# wsl 오프라인 설치 (개발망, 폐쇄망)

- 요즘 윈도 최신버전에서는 Powershell에서 `wsl --install`만 쓰면 한방 자동 설치가되는데,
- 여전히 윈도 구버전이거나 오프라인 환경에서는 수동설치가 필요
- https://learn.microsoft.com/ko-kr/windows/wsl/install-manual
- 공식 홈페이지에서는 "이전 버전에 대한 수동 설치(install manual)"라고 표현해서 눈에 잘 안띄는데, 버전에 상관없이 오프라인 설치는 이걸 보면됨
- 위 링크에서 OS 배포판 다운로드(*.AppxBundle파일)
- 내부망으로 배포판 파일 이동



powershell에서 wsl status 명령어 수행
=> Linux용 Windows 하위 시스템(WSL)이 설치되어 있지 않습니다. 'wsl.exe --install'을 실행하여 설치할 수 있습니다.
라는 메시지가 뜨는데, 해당 명령어는 온라인 용이므로 패스

```sh
#우선 로컬 환경에서 WSL 및 VM 환경 활성화를 수동으로 해줘야한다
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# 이후 한번 PC 재부팅

```

여기까지 WSL이 설치된 것이고, 다시 wsl status를 해보면 wsl을 업데이트하라고 나온다.
보통 이 업데이트 과정을 아래와 같이 표현하는데 다 똑같은 말이다.

- WSL(Linux용 Windows 하위 시스템)을 업데이트한다.
- = WSL2를 설치한다
- = 리눅스 커널을 업데이트한다.

"WSL2 Linux 커널 업데이트 패키지"를 공홈링크에서 수동다운로드하여 오프라인환경으로 옮겨서 설치해준다.

원래는 업데이트도 간단한 명령어로 가능하지만, 오프라인 환경이므로 설치파일을 별도 받아줘야 한다.



```
"Add-AppxPackage .\app_name.appx
```