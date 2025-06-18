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

# json에서 컬럼값 검색
jq 'select(.컬럼명 == "값")' 파일명.json

# 하위디렉토리의 모든 log 파일 합쳐서 생성
find . -name "*.log" -exec cat {} + > merged.txt

# 시간 범위 (DateTime)
jq -c 'select(.DateTime >= "2025-06-10T00:00:00+00:00" and .DateTime <= "2025-06-16T23:59:59+00:00")' input.json

# diff 결과물에서 내용만 추출
diff A.log B.log | grep '^[<>]' | sed 's/^[<>] //'
```
