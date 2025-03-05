# crontab: 주기적 작업 등록

자주 쓰는 크론탭 기능 정리

## 커맨드

```sh
# 조회
crontab -l

# 편집
crontab -e
```

## 크론탭 시간 설정

```sh
* * * * * command
```

- 앞에서부터  `*`에 지정
  - 분(0-59)
  - 시간(0-23)
  - 일(1-31)
  - 월(1-12 또는 JAN-DEC)
  - 요일(0-7, 여기서 0과 7은 일요일)
- 크론탭 지원 최소 단위는 분 단위임
  - 초단위 필요시 sleep 사용 (오차 가능성 있음)

## 크론탭 설정 예시

```sh
# 특정 시각에 쉘명령어 date 실행
0 1 * * * date   # 매일 1시
0 0 * * * date   # 매일 자정
0 18 * * * date  # 매일 18시
30 * * * * date  # "매시" 30분

# 특정 시간 주기로 쉘명령어 date 실행
*/30 * * * * date  # 30분"마다" 실행
*/10 * * * * date  # 10분마다 실행
*/1 * * * * date  # 1분마다 실행

# 월요일마다 8시에 실행
0 8 * * 1 date
# 매월 1일 오전 1시에 실행
0 1 1 * * date

# 스크립트 실행
  # 절대경로 사용
  # chmod로 실행가능 권한 부여 필요
0 1 * * *  /home/ubuntu/workspace/myscripts.sh
  # 홈 경로 사용 가능 (crontab을 실행하는 '사용자'에 주의)
0 1 * * *  ~/workspace/myscripts.sh                      
  # 해당 경로로 이동 후 실행 가능
0 1 * * *  cd /home/ubuntu/workspace/ && ./myscripts.sh  
```

## 자주 쓰는 크론탭 패턴

```sh
# 1분마다 시간기록 남기기
*/1 * * * * date >> ~/cron_time.log

# 10분마다 스토리지 기록 남기기
*/10 * * * * (echo -n $(date)'@@@@@' && df -h | grep /dev/ ) >> ~/storage.log
```

## root 권한

- `sudo crontab` 사용
- root user의 profile로 실행하게 되는 것이므로 **실제 실행될 커맨드에는 sudo를 붙이지 않아도 됨**
- 단, 환경설정은 root 기반으로 미리 되어있어야 함
  - e.g. awscli를 크론탭 내부에서 사용시,  `sudo aws configure`로 사전설정이 되어 있어야 함. `aws configure`은 안됨.

```sh
# 권장: sudo crontab -e 실행 후 다음과 같이 sudo 없이 기술
* * * * * command
```

```sh
# 비권장: crontab -e 실행 후 다음과 같이 sudo와 기술
# 이러면 커맨드 실행시 패스워드 입력을 요구받아, 로직이 중단될 수 있음
* * * * * sudo command
```
