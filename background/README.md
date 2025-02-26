# 백그라운드 실행

## Linux 내장 백그라운드 기능

```sh
# &: 백그라운드 실행
mycommand &

# nohup(no hang up): 터미널 세션 종료시에도 백그라운드 실행 보장
nohup mycommand &

# nohup에 sudo 붙이면 mycommand에도 root 권한 보장
sudo nohup mycommand &
```

## 백그라운드 스케줄링 crontab과 at



## Linux 추가설치 백그라운드 기능(스케줄링)

```sh
sudo apt install -y at

# 예약작업 목록조회
atq

# 예약작업 취소
atrm {JOB_NUM}

# 예약작업 등록
echo "mycommand" | at 14:30
echo "mycommand" | at 2:30 pm
echo "mycommand" | at now + 1 hour
echo "mycommand" | at now + 2 days
echo "mycommand" | at now + 10 minutes

# sudo at 실행시 내부 커맨드에도 root권한 적용됨
# sudo at으로 등록한 커맨드는 sudo atq,  sudo atrm 으로 제어
echo "mycommand" | sudo at 14:30

# sudo 적용 비추천사례 => 패스워드 입력 요구받아서 실패함
echo "sudo mycommand" | at 14:30

echo " cd /home/myuser/project/ &&  myrootcommand  " 

# 특성: 백그라운드 및 터미널 미점유 (nohup과 &이 필요없음)


```

## Docker 백그라운드

```sh
# -d: docker run 할 때 백그라운드 실행
docker run -d myimage 

# -d: docker compose up 할 때 백그라운드 실행
docker compose up -d
```

## Linux 서비스

```sh
# systemd
sudo systemctl start myapp.service
sudo systemctl stop myapp.service
sudo systemctl restart myapp.service
sudo journalctl -u myapp.service  # 특정 서비스만 골라서 로그 상세보기(u 옵션)
sudo journalctl -f -u myapp.service  # 

# service
sudo service myapp start
sudo service myapp stop
sudo service myapp status

## => systemd와 service의 차이는 wsl 디렉토리의 마크다운을 참고
```

## tmux 세션

- restart같은 기능처럼 robust한 관리는 힘들지만 빠르게 백그라운드 프로세스 띄울 때 아주 유용하다.

## Linux에서 백그라운드 프로세스 검색하기

```sh
# 가장 기본적이지만 옵션을 섬세하게 쓰지 않으면 사용하기 번거로움
# 프로세스가 너무 많이 보이거나, 너무 적게 보임
# 검색도 번거로움
ps

# 추천: 프로세스 검색하기. 이름 일부만 입력해도 유관 프로세스를 모두 찾아줌
pgrep -fl {프로세스 검색 키워드}

# 특히, child process, 다른 사용자(sudo 등)로 실행한 앱 등을 찾을 떄 pgrep이 편함
```
