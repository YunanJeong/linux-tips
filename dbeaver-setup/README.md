# dbeaver-setup

리눅스에서 dbeaver 셋업

## [공식 다운로드 페이지](https://dbeaver.io/download/)

- Linux, Windows 버전, deb패키지 설치, apt 설치, archive(jre 포함, 미포함) 다 있기는 하다.

## 23버전 이후 [이슈](https://github.com/dbeaver/dbeaver/issues/19783)

- Ubuntu에서 `libswt-gtk-4-java`가 설치되어있지 않으면 실행 불가
- dbeaver 배포판에 포함되어있지 않음. 별도 설치 필요.

```sh
# 추가 라이브러리 설치
sudo apt install libswt-gtk-4-java
```

## 아카이브 설치 (권장)

- java(jre)포함된 아카이브 버전을 다운받는 것이 가장 편하다.
  - jdk를 별도로 안설치해도 되고, 비인터넷 환경에서 쓰기도 좋다.
- 압축풀고 실행파일만 실행하면 된다.

```sh
# 다운로드
wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

# 압축풀기
tar xvzf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

# 추가 라이브러리 설치 
sudo apt install libswt-gtk-4-java

# 실행
./dbeaver/dbeaver
```

## deb 패키지 설치

- java 17 이상 요구

## CloudBeaver

- dbeaver가 도커허브로 제공하는 CloudBeaver라는 이미지
- 비슷한 기능의 다른 앱이다.
- DB 매니저 UI를 웹기반으로 접근할 수 있다.
- DB 매니저 자체를 원격 서버에 설치한다고 했을 때,,,
  - dbeaver는 ssh 접속 터미널에서 실행시 UI가 따로 실행되는데
  - CloudBeaver는 따로 웹 접속용 포트도 있어야 할 것으로 보인다.
