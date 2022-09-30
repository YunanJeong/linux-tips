# file-descriptor-settings
How to set file-descriptor in Linux, ElasticSearch, Kafka, ...

# 설정값 확인
- `$ulimit -n`
- `$ulimit -Hn`
- `$ulimit -Sn`

# 설정하기
- `$ulimit -n {number}`
    - 임시적용
- `/etc/security/limit.conf`
    - 새로운 세션 접속부터 적용
    - 자동화할 때는 다음 예시와 같이 쓸 수 있다.
        - `$sudo su -c "echo 'ubuntu nofile soft 128000' >> /etc/security/limits.conf"`
        - `$sudo su -c "echo 'ubuntu nofile hard 128000' >> /etc/security/limits.conf"`

# debian package(*.deb 파일)로 설치시
- Elasicsearch의 경우 별도 설정이 필요 없다.

# systemd service로 실행시
- 시스템 설정의 file-descriptor값은 무시된다.
- 서비스 파일의 [service]에서 다음 예시처럼 설정해준다.
    - `LimitNOFILE=128000`