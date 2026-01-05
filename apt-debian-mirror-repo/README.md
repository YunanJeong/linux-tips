# debian package mirror server

apt install할 때 쓰는 카카오 미러 서버(사설 저장소) 등록하기

## `/etc/apt/source.list.d/*.sources`

- /etc/apt/source.list.d/ 경로에서 "신규 sources 파일"을 생성해주고 아래와 같이 내용을 입력하면 된다.
- 해당 경로는 Ubuntu 24/26 이상 기준임
- 버전에 따라 입력할 내용이 다를 수 있는데, 해당 경로에 기본 ubuntu.sources 파일이 있으므로 이를 참고하여 미러서버 주소를 입력해주면 됨

```/etc/apt/source.list.d/kakao.sources
Types: deb
URIs: http://mirror.kakao.com/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

- 적용

```
# /etc/apt/source.list.d/kakao.sources 생성 후, 적용을 위해 update
sudo apt update
```

## /etc/hosts도 잊지말자

- 사설 저장소가 필요하다면, 온프레미스 환경에서 실제 주소가 아닌 우회주소를 사용할 가능성이 있을 것이다.
- /etc/hosts에 다음과 같이 사용하는 주소와 alias도 적어주자

```
# /etc/hosts
x.x.x.x mirror.kakao.com
```