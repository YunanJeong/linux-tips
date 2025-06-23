# WSL Storage Care

## 문제

WSL이 호스트의 스토리지를 제한없이 동적으로 썼다가 반환하지 않음

## 해결

WSL에서 안 쓰는 스토리지 반환하도록 최적화

- 관리자 권한 파워쉘에서 다음 실행

```powershell
# wsl 종료
wsl --shutdown

# 최적화("Windows 기능 켜기/끄기"에서 Hyper-V 활성화 상태여야 명령어 사용가능)
Optimize-VHD -Path {ext4.vhdx파일 절대경로} -Mode Full
```

- ext4.vhdx 파일 위치 찾는 법
  - 레지스트리 편집기에서 다음 경로로 이동한다.
  - `컴퓨터\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\`
  - 한 단계 더 하위경로인 중괄호 {}로 구성된 폴더로 진입하면 BasePath를 확인할 수 있다.
  - [공홈](https://learn.microsoft.com/ko-kr/windows/wsl/disk-space)에 따르면 CLI 커맨드로도 찾을 수 있다.

## 해결2

[스토리지 여유가 있는 다른 드라이브로 ext4.vhdx 옮기기](https://toridori.tistory.com/179)

- 관리자 권한 파워쉘에서 진행

```powershell
# 현재 배포된 WSL의 이름 확인
> wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Running         2

# 경로변경할 대상 WSL을 파일로 추출
# wsl --export {WSL 배포 이름} {추출 파일명.tar(경로포함)}
> wsl --export Ubuntu F:\wsl\Ubuntu.tar

# 실행중인 WSL 등록 취소
# wsl --unregister {WSL 배포 이름}
> wsl --unregister Ubuntu

# 추출한 파일을 다시 import
# wsl --import {WSL 배포 이름} {새로운 ext4.vhdx 저장경로} {추출 파일명.tar(경로포함)}
> wsl --import Ubuntu F:\wsl\Ubuntu F:\wsl\Ubuntu.tar

# 확인
> wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Running         2

# {새로운 ext4.vhdx 저장경로} 확인
# 기존 ext4.vhdx는 삭제됨
# tar파일은 백업파일로서 남아있다. 필요없으면 삭제해도 됨.
```

이후 기본 로그인 계정이 root로 되어있을 수 있으니 변경해준다.

```powershell
# ubuntu config --default-user {기존 사용하던 유저명}
> ubuntu config --default-user ubuntu
```

또는 wsl ubuntu 내부의 `/etc/wsl.conf`에서 다음과 같이 설정 후 wsl 재부팅

```/etc/wsl.conf
# /etc/wsl.conf
[user]
default=ubuntu
```

## 용어

- ext4: 리눅스 파일 시스템 형식 중 하나. 4는 버전.
- vhdx: 윈도우의 Hyper-V 가상 하드 디스크 파일 형식
- ext4.vhdx: ext4 파일 시스템을 Hyper-V에서 사용하기 위해 변환된 파일 형식
