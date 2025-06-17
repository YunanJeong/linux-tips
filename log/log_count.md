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
```
