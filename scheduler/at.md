
# at: 일회성 작업 등록

```sh
# 설치(Ubuntu 기준 기본 내장 앱은 아님)
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
echo "mycommand" | at 08:00 tomorrow
```

## Root 권한

```sh
# sudo at 실행시 내부 커맨드에도 root권한 적용됨
# sudo at으로 등록한 커맨드는 sudo atq,  sudo atrm 으로 제어
echo "mycommand" | sudo at 14:30

# sudo 적용 비추천사례 => 패스워드 입력 요구받아서 실패함
echo "sudo mycommand" | at 14:30
```

## 특정 프로젝트 경로에서 실행

```sh
# 특정 경로에서 실행 필요시
echo " cd /home/myuser/project/ &&  mycommand  " | at now

# 특정 경로에서 순차대로 여러 명령어 실행시 (OS마다 다르지만 보통 mycommand2에도 해당 경로 적용됨)
echo " cd /home/myuser/project/ &&  mycommand1 ; mycommand2 "  | at now
```

## 백그라운드 실행용으로 사용

- at now를 백그라운드 실행용으로 사용가능
- at 자체가 특성: 백그라운드 및 터미널 미점유 효과가 있음 (nohup과 &이 필요없음)

```sh
echo "mycommand" | at now
```

## 여러 명령어 실행

```sh
# echo
echo "cmd1 ; cmd2 ; cmd3" | at now

# here-doc
at now <<EOF
cmd1
cmd2
cmd3
EOF
```
