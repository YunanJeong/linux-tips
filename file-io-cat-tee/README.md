# file-io-cat-tee

- 자동화할 때 활용되는 파일 쓰기 기법

## cat

```sh
cat << EOF > example.json
{
  "foo": "bar"
}
EOF
```

- `<< EOF`
  - 명령어의 인자로 다중 라인 입력을 할 것(`<<`, Here Document)이며, EOF라는 문자열이 입력되면 다중 라인 입력이 끝난 것이라는 의미
  - `EOF`는 관례적인 단순 문자열이며, EOF 대신 임의 문자열을 종료마커(Delimiter)로 정의가능
- `> example.json`
  - example.json로 명령어의 출력을 내보냄 (`>`, Redirection)

## root 권한

- root 권한이 필요한 경로에 파일을 생성한다고 하자
- 다음과 같은 경우 실패한다.

```sh
# 사용 불가: sudo가 리다이렉션(>)에 적용 안 됨
sudo cat << EOF > /etc/example.json
{
  "foo": "bar"
}
EOF
```

### 해결1. /tmp 경로에서 생성 후 sudo mv

```sh
# 대부분 리눅스 배포판에서 /tmp 경로는 권한, 계정에 상관없이 활용가능
sudo cat << EOF > /tmp/example.json
{
  "foo": "bar"
}
EOF

# 대상 경로로 파일 이동 (mkdir -p는 대상 경로 없을 때만 생성)
sudo mkdir -p /etc/myapp/
sudo mv /tmp/example.json /etc/myapp/example.json
```

### 해결2. sudo tee 사용

- 입력을 `파일출력과 표준출력으로 둘 다 내보내는` 명령어
- 데비안 패키지 `coreutils`에 포함
- Ubuntu 등 대부분 Linux 배포판에 포함되나, Alpine 등 경량 배포판엔 없을 수 있음
- tee 명령어 내에 파일쓰기 기능이 있기 때문에 sudo가 잘 적용됨
- 보안이 중요한 파일일 경우 표준출력을 제거하면 좋기 때문에 `> /dev/null`을 붙임

```sh
# tee {filepath} {input}
sudo tee /etc/myapp/example.json << EOF > /dev/null
{
  "foo": "bar"
}
EOF
```
