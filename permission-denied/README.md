# 권한 관련 이슈

## permisson-denied

- 파일권한 변경시 사용
- 특히 *.sh파일을 새로 생성하면 실행가능하도록 허용필요

```shell
sudo chmod +x {대상file}
```

## vscode로 wsl에서 작업시 권한 문제로 수정이 안된다고 할 때

- 보통, 파일들을 다른 디렉토리로 복제하고 작업을 시도할 때 이런 문제가 발생

```shell
sudo chown -R {계정} {대상디렉토리}
```

## sudo 명령어를 비번 없이 사용하기

- 특히, sudo 명령어를 `.bashrc`에 등록하고 싶은 경우 유용
- `/etc/sudoers.tmp`를 편집해야하는데, 보안상 권장되는 방법은 아님

```sh
# 다음 명령어로 /etc/sudoers.tmp 편집기 진입(nano가 사용됨)
sudo visudo
```

- 맨 아랫줄에 다음 내용 등록

```sh
# {username} ALL=NOPASSWD:{명령어}

# 모든 명령어 sudo 없이 쓰기 예시(비권장)
ubuntu ALL=NOPASSWD:ALL

# 특정 명령어 sudo 없이 쓰기 예시
ubuntu ALL=NOPASSWD:/usr/bin/chmod 644 /etc/rancher/k3s/k3s.yaml
```

- 위 예시에서는 chmod를 sudo없이 쓰려고 하는데, 명령어를 바로 쓰면 안되고 `which {명령어}`로 원본 바이너리파일 경로를 찾아서 등록해주어야 함

- 내용을 수정했으면 `Ctrl+S`, `Ctrl+X`로 저장 및 종료한다. (nano편집기 조작)
