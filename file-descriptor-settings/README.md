# file-descriptor-settings

How to set file-descriptor in Linux, ElasticSearch, Kafka, ...

## 현재 설정 확인

```sh
ulimit -n
ulimit -Hn
ulimit -Sn
```

## 설정 변경 방법

```sh
# 임시 설정 방법 (현재 세션만 적용)
ulimit -n {number}

# 영구 설정 방법 (신규 세션부터 적용)
# /etc/security/limit.conf 수정
sudo su -c "echo 'ubuntu nofile soft 128000' >> /etc/security/limits.conf"
sudo su -c "echo 'ubuntu nofile hard 128000' >> /etc/security/limits.conf"
```

## debian package(*.deb 파일)로 설치시

- 기본 값이 적절하게 설정되어, 별도 설정은 필요없는 경우가 많음
  - e.g. ElasicSearch

## archive파일로 설치 후 systemd service로 실행시

- 시스템 설정의 file-descriptor값은 무시된다.
- 서비스 파일의 `[service]` 항목에서 다음 예시처럼 지정 필요

```properties
LimitNOFILE=128000
```
