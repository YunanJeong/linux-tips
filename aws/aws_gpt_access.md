# AWS EC2에서 CHATGPT 서비스 접속

- OS는 ubuntu24이고, MobaXterm으로 접속

## 초기설정

```sh
# 엣지 브라우저 공식 설치 파일
wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_135.0.3179.73-1_amd64.deb

# 설치
sudo apt install ./microsoft-edge-stable_135.0.3179.73-1_amd64.deb

# GUI(브라우저)에서 한국어 출력 지원
sudo apt update
sudo apt install -y fonts-nanum
sudo fc-cache -fv

# GUI에서 한국어 입력 지원 
sudo apt update
sudo apt install -y ibus ibus-hangul
ibus restart
echo "export GTK_IM_MODULE=ibus" >> ~/.bashrc
echo "export QT_IM_MODULE=ibus" >> ~/.bashrc
echo "export XMODIFIERS=@im=ibus" >> ~/.bashrc
# 입력기(ibus) 상시 실행되도록 설정 # 이름만 daemon이지 세션 끄면 죽기 때문에 등록 필요
echo "ibus-daemon -drx" >> ~/.bashrc
source ~/.bashrc

# 입력기 설정창 GUI 열기 (ibus-daemon -drx 사전실행 필요)
ibus-setup
# 입력기 설정 GUI - Input Method - Hangul(또는 Korean, Korean 101/104) 찾아서 추가
  # 전환 키도 설정가능한데 default인 슈퍼스페이스(shift+space)가 리눅스에서 가장 보편적
  # 한/영키는 Ubuntu OS 및 키보드 하드웨어 스펙에 따라서도 다를 수 있음

# 엣지브라우저 실행 => chatgpt 접속  (ibus-daemon -drx 사전실행 필요)
microsoft-edge
```

## 이슈 정리

### MobaXterm에서 GUI 사용 불가한 문제

해결: snap으로 배포되는 앱 대신 debian 패키지로 배포되는 앱을 사용할 것

- 관련된 기능(`X11 forwarding`)이 활성화 되어 있어야 함
  - 원격 EC2 서버와 MobaXterm에서 이미 default로 활성화된 경우가 많음
- 관련 파일 및 권한 이슈로 GUI가 활성화 되지 않는 경우가 있는데, 주로 `snap`으로 배포된 앱들이 이런 문제를 겪음
- 순수하게 데비안 패키지(`apt install *.deb`)로 설치되는 앱들은 GUI가 정상실행됨

```error
# firefox, chatgpt-desktop  GUI 실행시 에러 메시지
PuTTY X11 proxy: No authorisation provided
Error: cannot open display: server:10.0
```

```sh
# 아래와 같이 ~/.bashrc에 등록해두면 대부분 해결
export XAUTHORITY=$HOME/.Xauthority
```

- 위 방법으로 chatgpt-desktop(사설앱)은 GUI 실행이 됨
- firefox는 여전히 다른 X11이슈로 실행이 되지 않음
- 관련 이슈가 너무 많으므로, 그냥 데비안 앱으로 진행하는 것을 추천
  - chrome이나 edge 등의 브라우저는 데비안 패키지 배포가 됨

### ChatGPT는 VPN 접속시 로그인을 막음

- `Oops`라면서 나중에 로그인 시도하라고 함
- 시간대를 변경하거나, Edge 브라우저를 사용하면 이 문제 회피
