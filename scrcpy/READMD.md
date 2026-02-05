# `scrcpy`(스크린카피)

- Galaxy에서 One UI 7부터 Dex for PC 지원 종료
- scrcpy를 대체재로 사용
- 윈도 기능인 Links to Windows가 있긴한데, 아직 부실하고 윈도우 계정 로그인을 요구함
- https://github.com/Genymobile/scrcpy 의 releases에서 다운로드
- OS별 단순 실행파일 1개로 구성되며, 의존성으로 사용하는 adb 실행파일도 포함

## How to Use

- 환경: Android16, OneUI8.0, Windows11, scrcpy3.3.4

### 폰에서 개발자옵션 사전설정

- `USB 디버깅` 활성화
  - `설정 - Auto Blocker(보안 위험 자동 차단)` 기능을 먼저 비활성화해야 설정 가능
  - 시스템 권한을 노출하는 설정이므로 `하단의 보안 유의 사항 참조 필수`
- `보조 디스플레이에서 자유 형식 창 활성화(freeform windows on secondary display)` 활성화
  - 보조 디스플레이에서 앱을 창모드로 실행하여 위치조정 가능
  - 비활성화시 앱이 전체화면을 점유
- `활동의 크기가 조정 가능하도록 설정` (필요시 활성화)
  - 앱 크기가 고정된 앱에서 앱 모서리를 드래그하여 강제 리사이징 가능
- `모든 앱에서 멀티윈도우` (필요시 활성화)
  - 멀티윈도우(폰에서 멀티윈도, scrcpy에서 창모드 기능)를 미지원하는 앱에서 강제적용
- 참고
  - 대부분 현대적인 앱은 유연한 UI레이아웃을 이미 지원하므로, "활동의 크기가 조정 가능하도록 설정"과 "모든 앱에서 멀티윈도우"가 필요없음
  - 단, 정책상 레이아웃이 고정된 일부 금융/보안/게임 앱의 제어를 위해서는 활성화 필요
  - 모두 활성화했음에도 불구하고 scrcpy에서 전체화면이 강제되는 앱이 있는데, scrcpy를 여러 개 실행시켜 멀티태스킹하는 방법도 가능

### 해당 PC의 USB 디버깅 허용 팝업

- 케이블 연결된 상태로 진행
- scrcpy 실행시 폰에 뜨는 팝업창에서 "허용" 선택
  - 이는 `개별 PC에 대해 승인하는 절차`폰에서 USB 디버깅 기능이 활성화되어 있어도, 항상 새 PC는 새 인증 팝업이 나오므로 안전
  - "이 컴퓨터에서 항상 허용"시 대상 PC가 생성한 RSA공개키를 폰에 저장하여, 이후 재연결 시 자동 인증됨, `개발자 옵션-USB 디버깅 권한 승인 취소`에서 일괄 삭제가능
- 팝업을 끈 경우, 케이블을 재연결하거나, 상단바 알림 중 "USB 설정"에서 USB 사용 용도를 바꾸면 재인식된다. (최종적으로, USB사용용도는 충전모드로만 해둬도됨)

### scrcpy 실행

- 케이블 연결된 채로 scrcpy 파일 실행

```sh
# 옵션없이 default 실행(단순 미러링)
scrcpy

# 가상 디스플레이 옵션
# 폰에 외부 디스플레이를 붙인것으로 인식시킴. 여러 개 가능.
# 해상도와 dpi(글자크기 조정)을 설정
scrcpy --new-display
scrcpy --new-display=1920x1080/200
scrcpy --new-display=2560x1200/120

# 물리키보드 활성화(한글입력시 필요)
scrcpy --keyboard=uhid
```

- 커스텀 스크립트 만들어서 실행도 가능

```ps1
# 로컬에서 만든 파워쉘스크립트는 실행 허용하도록 윈도 정책 변경
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# 커스텀 스크립트 실행
./scrcpy_pivot.ps1
```

```ps1
# example: scrcpy_pivot.ps1

# 실행파일 경로
cd $env:USERPROFILE\scrcpy-win64-v3.3.4

# 폰의 디버깅 허용 대기
.\adb wait-for-device

# 커스텀옵션실행
.\scrcpy.exe --new-display=1080x1920/200 --keyboard=uhid

# 사용끝나면 adb도 종료
.\adb kill-server

# PC의 adb RSA키 삭제
# 폰에서 항시 허용하더라도, 향후 재연결시 새 RSA키 생성하여 새 인증받도록 함 (내 PC도 믿기힘들면 사용)
Remove-Item -Force -Path "$env:USERPROFILE\.android\adbkey*" 
```

### 사용 후

- adb 프로세스 종료
- scrcpy 실행시 동일경로의 adb.exe를 실행시켜 활용하는데, 사용 후 꺼주는 것이 안전
- 작업관리자에서 끄던가 `adb kill-server`

## 보안 유의 사항

- scrcpy 자체
  - 프랑스 업체 GenyMobile에서 제공
  - Github 소스코드 공개되어있고, 널리 사용됨
  - 어느정도 공신력이 있으므로 믿어도 될 듯
- adb 주의
  - `정상 연결된 상태에서 사실상 폰의 모든 권한을 PC에서 가짐`을 감안할 것
  - 기존 Dex for PC는 삼성 독자 프로토콜을 쓰므로 adb를 사용하지 않았었음
  - scrcpy종료 후에도 adb 프로세스가 계속 살아있으므로 수동 종료할 것
- 잠금 화면 보호
  - 안드로이드 11 이상 기본 정책에 의해, 폰이 잠겨(Lock) 있으면, 이미 인증된 PC라도 일부 ADB 명령이 거부되므로, 폰 화면만 잠궈도 1차 방어 가능
- 개별 PC들에 대한 디버깅 권한 관리
  - 폰에서 `개발자 옵션-USB 디버깅 권한 승인 취소`에서 일괄 삭제 가능(저장해놓은 RSA키들 일괄 삭제)
  - 참고: PC의 RSA키는 adb 최초실행시 랜덤생성되며 `%USERPROFILE%\.android` 경로에 저장됨. 갱신 필요시 여기 있는 키파일을 삭제하고 adb 재실행하면 됨
- 스크립트(.ps1) 대신 바로가기(.lnk)로 실행하기
  - ps1은 보안이슈 타겟이 되기 쉽고 사용도 불편
  - "바로 가기"생성 후 `속성>대상`에서 One liner로 파워쉘을 등록해주자
  - OS차원의 파워쉘 정책 변경없이, 해당 명령어에 대해서만 제한 우회하는 방식
  
```sh
# 바로가기 대상용 원라이너 (이스케이프 주의, 260자 제한)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "[파워쉘_명령어]"

# 대상 example(cd 대신 바로가기의 "속성>시작위치" 활용하여 글자수 줄이기)
powershell.exe -NoP -ExecutionPolicy Bypass -C ".\adb wait-for-device; .\scrcpy.exe --new-display=1080x1920/330 --keyboard=uhid; .\adb kill-server; rm -Fo -Path $env:USERPROFILE\.android\adbkey* "
```
