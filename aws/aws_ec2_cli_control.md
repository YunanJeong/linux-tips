# awscli로 ec2 제어

```sh
# 현재 인스턴스 목록(이름과 id만) 출력
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`]|[0].Value,ID:InstanceId}' \
  --output table

# 강제 중지 (종료아님. 중지는 stop, 종료는 terminate)
aws ec2 stop-instances --instance-ids i-000myinstancdid --force

# 시작
aws ec2 start-instances --instance-ids i-000myinstancdid

# 상태체크 (종료중은 stopping, 종료됨은 stopped)
aws ec2 describe-instances \
  --instance-ids i-000myinstancdid \
  --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name}' \
  --output table
```
