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
