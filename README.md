# dbeaver-setup

리눅스에서 dbeaver 셋업

## [공식 다운로드 페이지](https://dbeaver.io/download/)

- Linux, Windows 버전, deb파일, apt install, archive(jre 포함, 미포함) 다 있기는 하다.

- 그래도 하나 정도 컨테이너로 만들어 둬도 편할 것 같긴하다.

- java 17 이상 요구

```sh
# deb 설치
sudo  wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update && sudo apt-get install dbeaver-ce

# deb 설치시 추가 설치 필요 (https://github.com/dbeaver/dbeaver/issues/19783)
sudo apt install libswt-gtk-4-java
```

## CloudBeaver

- dbeaver에서 제공하는 CloudBeaver라는 것도 있긴한데, 비슷한 기능의 다른 앱이다. DB 매니저 UI는 웹기반으로 접근할 수 있다.

- DB 매니저 자체를 원격 서버에 설치한다고 했을 때,,,
  - dbeaver는 ssh 접속 터미널에서 실행시 UI가 따로 실행되는데
  - CloudBeaver는 따로 웹 접속용 포트도 있어야 할 것으로 보인다.
  