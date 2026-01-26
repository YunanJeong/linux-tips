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
- 시간 변환은 가급적 피하는 것이 좋음
  - jq에서 DateTime을 timestamp로 변환하는 함수(fromdateiso8601)를 제공하긴 하는데, 이런 변환의 경우 버전에 따라 동작이 다르거나, 소수점 단위 처리에서 오차 발생가능성이 있음

```sh
# 일반적인 DateTime인 경우에도 숫자처럼 문자열 대소비교해도 정확함
jq -c 'select(.DateTime >= "2025-06-10T00:00:00+00:00" and .DateTime <= "2025-06-16T23:59:59+00:00")' input.json
```

### 로그 파일에서 시간필드 내 값 표기가 제각각인 경우

```

```

```
cat logs.json | jq -c 'select((.DateTime | sub("Z$"; "+00:00")) >= "2026-01-21T05:00:00.000+00:00" and (.DateTime | sub("Z$"; "+00:00")) <= "2026-01-25T00:00:00.000+00:00")'
```