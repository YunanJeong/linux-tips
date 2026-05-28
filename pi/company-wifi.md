# 라즈베리파이에서 회사규격 Wifi(WPA/WPA2 Enterprise) 연결하기 (2026.05.15.)

- 상황: Windows, Android, iOS 등 타 OS는 제공된 가이드에 따라 사내 WPA/WPA2 Enterprise Wi-Fi에 정상 연결됨
- 문제: 라즈베리파이 OS(데비안 13 트릭시) 환경에선, 다른 OS용으로 제공되는 Wifi 가이드로 적당히 설정했으나, 연결이 불가능하거나 일시적 연결 후 즉시 튕김.

## 주요 문제 원인

1. **리눅스 GUI 버그:** 그래픽 설정 창에서 'CA 인증서 없음'을 체크해도 실제 백엔드 파일에 완벽히 반영되지 않아 인증 서버와 패킷 충돌 발생
   - 이것때문에 처음엔 Wifi랑 handshake 조차 안됨
2. **엄격한 보안 정책:** 최신 리눅스 커널이 구형 사내 AP 장비의 암호화 규격(TLS/CA 미검증)을 보안 위협으로 간주하여 세션을 스스로 파괴
   - Wifi 초기 연결은 됐는데 라즈베리파이 Client 측에서 연결 끊어버림
3. **가상 MAC 주소 차단:** 리눅스가 개인정보 보호를 위해 무작위로 생성한 가상 MAC 주소를 사내 보안 장비가 '부적격 기기'로 판단해 접근 거부

##  해결

- `/etc/NetworkManager/system-connections/[Wi-Fi_이름].nmconnection` 수정하고 `NetworkManager` 서비스 재실행하여 반영
- GUI 설정에 따라 이 파일 내용도 변경되나, 일부옵션은 파일에서 지정해야 함
- 현재 연결시도상황이 어떠한지는 `NetworkManager` 로그를 통해 간접확인가능(다른문제 발생시에도 트러블슈팅으로 참고)

```ini
[wifi]
...
# 동일이름의 AP장비가 여러 개 있을때 AP물리장비 고정하기.(nmcli dev wifi 명령어로 그나마 가장 신호가 센 장비 확인. 여러 AP의 신호세기가 애매할 때 왔다갔다하는 현상을 방지함)
bssid=XX:XX:XX:XX:XX:XX
...

[wifi-security]
# key-mgmt: 인증 규격을 기업용 WPA-EAP 방식으로 강제 고정하여 자동 탐색 지연을 방지합니다.
key-mgmt=wpa-eap

# pmf: 관리 프레임 보호 기능 설정 (1=선택 사용, 0=비활성화)
# 사내 AP 장비와 리눅스 간의 보안 규격 엇박자로 인한 타임아웃을 방지합니다.
pmf=1

[802-1x]
# eap: 1단계 외곽 인증 방식으로 PEAP 규격을 명시합니다. (끝에 세미콜론 필수)
eap=peap;

# phase2-auth: 2단계 내부 암호화 방식으로 mschapv2를 강제 지정합니다.
phase2-auth=mschapv2

# system-ca-certs: 시스템에 저장된 CA 인증서 검증 기능을 해제(GUI에서 해당부분을 체크했더라도 적용안되므로 여기서 지정 필요)
system-ca-certs=false

# phase1-auth-flags: 숫자 '32'는 내부적으로 '인증서 체크 강제 무시(No CA)'를 뜻하는 비트마스크 플래그입니다.
# 파일에 직접 이 플래그를 박아주어야 인증 서버와의 패킷 충돌 시 즉시 튕기는 현상이 사라집니다. (해결의 핵심 항목)
phase1-auth-flags=32

# password-flags: 비밀번호 저장 방식을 시스템 계정 전용(0)으로 락을 겁니다.
# 내부 인증 지연 시 'no-secrets(비밀번호 없음)' 예외 에러로 빠져 연결이 터지는 것을 막아줍니다. (해결의 핵심 항목)
password-flags=0

[connection]
# wifi-cloned-mac-address: 리눅스의 가상 MAC 주소 무작위화 기능을 끄고, 실제 무선 랜카드의 고유 MAC(permanent)을 사용합니다.
# 회사 보안 장비(RADIUS)가 가상 MAC 주소를 차단하여 발생하는 결속 오류를 해결합니다.
wifi.cloned-mac-address=permanent

```

```sh
# NetworkManager 재실행
sudo systemctl restart NetworkManager

# 로그 최근 100줄 보기
journalctl -n 100 NetworkManager
```
