# crontab

자주 쓰는 크론탭 기능 정리

## 커맨드

```sh
# 조회
crontab -l

# 편집
crontab -e
```

## 크론탭 설정 예시

```sh
# 매일 1시마다 쉘명령어 실행
0 1 * * * date

# 스크립트는 절대경로 사용. chmod로 실행가능상태여야 함
0 1 * * *  /home/ubuntu/workspace/myscripts.sh

# 해당 경로로 이동 후 실행 가능
0 1 * * *  cd /home/ubuntu/workspace/ && ./myscripts.sh

0 1 * * *  /home/ubuntu/workspace/myscripts.sh

# 매 특정시간에 실행

# 1분마다 시간기록 남기기 (1분이 크론탭에서 최소)
*/1 * * * * date >> /home/ubuntu/cron_time.log

# 10분마다

# 30분마다

# 초단위 필요시 sleep 사용 (오차 가능성 주의)

```
