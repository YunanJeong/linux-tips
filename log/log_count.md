# Log Count

```sh
# 파일 라인 수 출력
wc -l file.log

# Stdout 라인 수 출력
cat file.log | wc -l

# 특정 경로 아래에 모든 파일의 각 라인 수와 총합 출력
# 해당 경로 뿐만 아니라 하위 모든 tree를 recursive하게 포함 
find /foo/bar -type f -name "*.log" -exec wc -l {} +
find . -type f -name "*.log" -exec wc -l {} +
find . -type f -name "250616_*.log" -exec wc -l {} +



# 하위디렉토리의 모든 log 파일 합쳐서 생성
find . -name "*.log" -exec cat {} + > merged.txt



# diff 결과물에서 내용만 추출
diff A.log B.log | grep '^[<>]' | sed 's/^[<>] //'
```

## jq 로 json 처리

```sh
# json에서 컬럼값 검색
jq 'select(.컬럼명 == "값")' 파일명.json

# json string을 json으로
jq 'fromjson' 파일명.json
cat 파일명.json | jq 'fromjson'
```

### 시간 범위 

- 문자열(ASCII)기반 대소비교가 가장 정확하다.
- timestamp<=>DateTime 시간 변환은 가급적 피하는 것이 좋음 

```sh
# 일반적인 DateTime인 경우에도 숫자처럼 문자열 대소비교해도 정확함
jq -c 'select(.DateTime >= "2025-06-10T00:00:00+00:00" and .DateTime <= "2025-06-16T23:59:59+00:00")' input.json
```

### 로그 파일에서 시간필드 내 값 표기형식이 제각각인 경우

- logs.json 예시
```json
{"DateTime":"2026-01-21T05:00:00.000+00:00", "serverId": 1}
{"DateTime":"2026-01-21T05:00:00.000Z", "serverId": 2}
```
- 원본 그대로 문자열 비교는 불가하므로, 동일포맷의 문자열로 일원화하자.
- timestamp 변환하는 것은 다소 애매하다.
  - jq에서 DateTime을 timestamp로 변환하는 함수(fromdateiso8601)가 제공되지만, 이런 변환은 버전마다 동작이 다르거나, 소수점 단위 처리에서 오차 발생하는 등 세부적인 예외사례가 있으므로 정밀한 사전테스트가 필요
-  jq Date and Time Functions
  - fromdateiso8601: Parses an ISO 8601 string into a Unix timestamp.
  - todateiso8601: Converts a Unix timestamp into an ISO 8601 string.
  - fromdate: Shorthand for fromdateiso8601.
  - todate: Shorthand for todateiso8601.
  - gmtime: Converts a timestamp into a UTC time array [Y,M,D,h,m,s,w,y].
  - localtime: Converts a timestamp into a local time array.
  - strftime("%Y-%m-%d"): Formats a time array into a custom string.
  - strptime("%Y-%m-%d"): Parses a custom string into a time array.
  - now: Returns the current Unix epoch time.

- logs.json에서 특정 시간범위만 추출
```sh
# 시간필드 값에서 Z표기를 +00:00으로 일괄 변환 후 시간범위 추출
# 쿼리 조건문에서만 변환하여 인식하는 것이고, 출력물은 그대로이므로 사용가능
cat logs.json | jq -c 'select((.DateTime | sub("Z$"; "+00:00")) >= "2026-01-21T05:00:00.000+00:00" and (.DateTime | sub("Z$"; "+00:00")) <= "2026-01-26T00:00:00.000+00:00")'
```

- 변환 테스트

```sh
# 위와 같이 변환쿼리 사용시 아래처럼 테스트 실행을 해보는 것이 좋다.
echo '["2026-01-19T00:00:00.144Z", "2026-01-19T00:00:00.144+00:00"]' | jq -r '.[] | "원본: \(.)  ->  변환: \(sub("Z$"; "+00:00"))"'
```

- 변환 테스트 출력결과
```
원본: 2026-01-19T00:00:00.144Z  ->  변환: 2026-01-19T00:00:00.144+00:00
원본: 2026-01-19T00:00:00.144+00:00  ->  변환: 2026-01-19T00:00:00.144+00:00
```