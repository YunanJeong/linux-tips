
# at: 일회성 작업 등록

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