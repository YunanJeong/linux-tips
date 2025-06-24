# wsl 오프라인 설치 (개발망, 폐쇄망)

- 요즘 윈도 최신버전에서는 Powershell에서 `wsl --install`만 쓰면 한방 자동 설치가되는데,
- 여전히 윈도 구버전 or 오프라인 환경에서는 수동설치 필요
- 오프라인설치 방법이 잘 나와있는 자료가 없어서 정리
- 공식 홈페이지에서 "이전 버전에 대한 수동 설치(install manual)"가 있긴한데, 그대로 따라하면 안되고 참고만 하자
  - 윈도우10 or 꽤 오래된 윈도우 버전일 때만 가능
  - `최신 윈도우11에선 "커널 업데이트" 수동설치 단계에서 정상진행 불가`
  - 정상진행해도 너무 복잡하다. 아래 방법이 훨씬 간단함.

## Windows11에서 WSL2설치

```sh
# 로컬 윈도우 환경에서 WSL 및 VM 활성화(관리자 권한 Powershell)
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# WSL 및 VM 환경 활성화는 윈도메뉴-Windows 기능 켜기/끄기로 진입하여 UI에서도 설정가능하다.(VM만 활성화돼있어도 WSL2설치 및 사용엔 문제없음)

# 설정 완료 후 PC 재부팅 필수
```

- 아래 파일들을 다운받아서 폐쇄망으로 이동 후 설치 진행
- 복잡한 절차없이 더블클릭 실행으로 설치가 깔끔하게 됨
  - [공식 깃허브의 Release 페이지](https://github.com/microsoft/WSL/releases)에서 wsl설치파일(*.msi)
  - [MS공홈](https://learn.microsoft.com/ko-kr/windows/wsl/install-manual#downloading-distributions)에서 OS 배포판(*.AppxBundle)

## 신규OS 대신 커스텀 배포판 만들어서 마이그레이션 (권장)

- 폐쇄망에 신규OS 배포판을 설치하기보다는, 인터넷 환경에서 미리 필요한 툴을 설치한 후 폐쇄망으로 마이그레이션하는 것이 편함

```powershell
# 인터넷 PC에 배포된 WSL의 이름 확인
wsl -l -v

# 인터넷 PC에서 배포판 export
# wsl --export {WSL 배포 이름} {추출 파일명.tar(경로포함)}
wsl --export my-ubuntu F:\wsl\Ubuntu.tar

########################################

# 폐쇄망 PC에서 import
# wsl --import {신규 WSL 배포이름} {신규 ext4.vhdx 저장경로} {추출 파일명.tar(경로포함)}
wsl --import my-ubuntu F:\wsl\Ubuntu F:\wsl\Ubuntu.tar
```

### vscode 연동 필요시

- vscode-server
  - 오프라인 설치 미지원
  - **인터넷 환경의 WSL 내부에서 `code .`를 1회라도 실행해야 vscode-server가 인터넷을 통해 설치됨**. vscode-server가 설치된 OS를 export한 후 폐쇄망에서 import해야 함.
- vscode extension
  - 인터넷 다운로드: vscode의 확장탭에서 특정 extension 오른쪽 클릭 - vsix 다운로드(또는 특정 버전)
  - 폐쇄망 설치: vscode의 확장탭 진입 후 확장창 우측 상단 (...) 메뉴 진입하여 "install from visx ..." 선택
- vscode, vscode-server, vscode-extension 모두 버전 호환성이 매우 중요하니, 인터넷 PC에 실제 세팅된 환경을 기반을 참고해야 함
