# 백그라운드 실행

```sh
# &: 백그라운드 실행
mycommand &

# nohup: 터미널 세션 종료시에도 백그라운드 실행 보장
nohup mycommand &

# nohup에 sudo 붙이면 mycommand에도 root 권한 보장
sudo nohup mycommand &
```

```sh
# -d: docker run 할 때 백그라운드 실행
docker run -d myimage 

# -d: docker compose up 할 때 백그라운드 실행
docker compose up -d
```
