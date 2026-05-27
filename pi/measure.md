# 라즈베리파이 상태 점검

```sh
# ~/measure.sh

# 온도
vcgencmd measure_temp

# 쓰로틀링 이력(발열, 전력부족, 과부하 이슈)
vcgencmd get_throttled

# 무선연결 상태 (Link Quality 비율은 대략적 연결강도로 해석,  dbm은 -30좋음, -80나쁨)
iwconfig | grep -Ei "wlan|Link Quality"
```

```sh
# 콘솔에서 1초마다 갱신
watch -n 1 ~/.measure.sh
```