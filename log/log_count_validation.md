# Log Count & Validation

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


# diff는 메모리를 많이 먹으므로 아래 대안이 있음

# 해시로 비교(대용량 파일도 금방처리하고 1비트만 달라도 다른값출력)
md5sum 파일명.json

# 두 파일간 첫번쨰로 다른 라인 찾기
cmp A.log B.log
```

## sort -u 시 parallel 적극 사용

- default는 단일코어
- 정렬/중복제거시 멀티코어 개수 지정
- 순서유지/데이터 꼬임 방지 등 멀티프로세싱에 의한 데이터 이슈를 내부적으로 방지해줌
  - 내부 Merge Sort 알고리즘+멀티스레딩

```sh
sort -u --parallel=[코어갯수] 파일명.json
cat 파일명.json | jq -c | sort -u --parallel=3
```

## jq 로 json 처리

```sh
# json에서 컬럼값 검색
jq 'select(.컬럼명 == "값")' 파일명.json

# json string을 json으로
jq 'fromjson' 파일명.json
cat 파일명.json | jq 'fromjson'
```

- cat 출력 후 파이프라인(| jq)처리는 비효율적이므로 대용량 파일에선 습관적으로 쓰지 않도록 주의

### jq 멀티프로세싱

- jq는 단일코어만 지원
- 멀티프로세싱은 별도 구현 필요
- 대용량 단일 파일 처리시 GNU Parallel(apt install parallel) 사용가능
  - "대용량 단일 파일에서 xargs는 사용금지"
    - => 순서보장 불가, 데이터 손상 위험, I/O 비효율(단일 파이프)
- 여러 파일로 나눌 수 있을 경우
  - 파일 나누고 jq 여러 개 실행, xargs, snakemake, or 각종 멀티프로세싱 도구 사용
- **parallel**
  * --pipepart : 파일을 물리적으로 쪼개지 않고 오프셋을 계산해 여러 프로세스가 단일 파일의 여러 위치를 동시에 찍어서 읽어 처리 속도를 극대화(멀티파이프, xargs가 이게 안됨)
    * 물리적인 단일파일에 대해 사용가능
    * `cat 파일명.json | parallel --pipepart` 와 같이 stdin 주입방식에선 효과없음
  * -a [파일명] : 병렬 처리할 입력 대상 파일을 직접 지정
  * --block [블록용량표기] : 한 번에 처리할 데이터 덩어리 크기
    * default 1M인데, 비효율적이므로 10~100M으로 설정필요
    * 100MB 내외가 I/O 효율 가장 좋음
  * -k (--keep-order) : 결과 출력 시 원본 데이터의 순서를 그대로 유지
  * -j 8 (--jobs 8) : 멀티코어 개수 지정
    * 0은 모든 코어 사용
    * 50% 등 퍼센트 지정 가능
    * default는 전체가용코어

```sh
# parallel -a [입력파일] --pipepart -k -j=[코어갯수] --block=[블록크기] "대상명령어"
# 대용량 단일 파일 parallel로 jq 처리
parallel -a 파일명.json --pipepart -k --block=128M --jobs=3 jq -c '.'

# 대상 명령어는 parallel에 인자로 들어가므로 따옴표 씌워주는 것이 안전
parallel -a 파일명.json --pipepart -k --block=128M --jobs=3 \
"jq -c '.message | fromjson' "

# 대상 명령어 이스케이프 주의 (",$,|,`,\,! 등)
parallel -a 파일명.json --pipepart -k --block=128M --job=3 \
"jq -c 'message | fromjson | select 'select(.status == \"200\")' "
```

```sh
# (제일편함)대상 명령어가 복잡하여 이스케이프처리가 힘든 경우 환경변수 활용
JQ_QUERY='.message | fromjson | select(.status == "200")'
parallel -a 파일명.json --pipepart -k --block=128M --job=3 \
jq -c '$JQ_QUERY'
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
- jq Date and Time Functions
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
jq -c 'select((.DateTime | sub("Z$"; "+00:00")) >= "2026-01-21T05:00:00.000+00:00" and (.DateTime | sub("Z$"; "+00:00")) <= "2026-01-26T00:00:00.000+00:00")' logs.json
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