# 라즈베리파이에서 키오스크 띄우기

- 환경: Raspberry Pi OS Trixie + labwc (Wayland)
- 목표: 최초 부팅 시 크로미움 자동 실행

## 사전 확인

```bash
echo $XDG_CURRENT_DESKTOP        # labwc 인지 확인
which chromium chromium-browser  # 실행파일 이름 확인 (둘 중 하나)
```

- Trixie 데스크톱은 기본이 labwc(Wayland, X11처럼 GUI앱 구현도구를 의미).
- Raspberry Pi OS에는 보통 가벼운 chromium이 기본 내장되어 별도 설치 없이 바로 사용 가능

## 크로미움 실행 스크립트

```sh
# ~/launch-chromium.sh

#!/bin/sh
# exec: 없어도 되는데, 자동실행시 쉘이 따로 남지 않도록 해줌

# --kiosk                          : 주소창/탭 없는 전체화면
# --password-store=basic           : 키링 비번 창 차단(브라우저 실행시 비번창 생략)
# --noerrdialogs                   : 오류 대화상자 끔
# --disable-infobars               : 상단 알림바 끔
# --disable-session-crashed-bubble : 정전/강제종료 후 "복원하시겠습니까" 팝업 차단
exec chromium --kiosk --password-store=basic \
  --noerrdialogs --disable-infobars \
  --disable-session-crashed-bubble \
  https://example.com
```

```bash
# 실행권한 부여
chmod +x ~/launch-chromium.sh
```


## labwc autostart 등록

```bash
mkdir -p ~/.config/labwc
vi ~/.config/labwc/autostart
```

```conf
# ~/.config/labwc/autostart
/home/pi/launch-chromium.sh &
```

- autostart 내용엔 절대경로로 기술
- 끝의 & 는 백그라운드 실행 표시. labwc는 autostart를 위에서 아래로 순차 실행하므로, & 가 없으면 chromium이 떠 있는 동안 그 줄에서 멈춰 뒤 줄이 실행되지 않을 수 있음

저장 후 재부팅:

```bash
sudo reboot
```


## 요약

1. 실행 스크립트 작성 + chmod +x
2. labwc autostart에 스크립트 경로 + & 등록
3. 재부팅
```