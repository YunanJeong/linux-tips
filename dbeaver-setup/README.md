# dbeaver-setup

리눅스(원격서버, 오프라인 환경)에서 dbeaver 셋업하는 방법을 정리

- DBeaver Community 버전은 `Apache 2.0 License`으로 작업 중 가볍게 쓰기 좋다.

- 보안상 원격 DB를 원격 서버에서 참조해야하는 경우가 있음

메모: 컨테이너를 써도 괜찮을 것 같긴한데... 개별 Driver를 인터넷으로 추가설치할 수 없으니, 자주 쓰는 Driver 까지 포함해서 만들어야 된다. 또 많은 Driver를 넣자니 버전관리가 귀찮아질듯

## [공식 다운로드 페이지](https://dbeaver.io/download/)

- Linux, Windows 버전, deb패키지 설치, apt 설치, archive(jre 포함, 미포함) 다 있기는 하다.

## 아카이브 설치 (권장)

- java(jre)포함된 아카이브 버전을 다운받는 것이 가장 편하다.
  - jdk를 별도로 안설치해도 되고, 오프라인 환경에서 쓰기도 좋다.
- 압축풀고 실행파일만 실행하면 된다.
  - 23버전대 기준, 추가 라이브러리 설치 필요(하단 libswt-gtk-4-java 참고)

```sh
# 다운로드
wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

# 압축풀기
tar xvzf dbeaver-ce-latest-linux.gtk.x86_64.tar.gz

# 실행(ssh 기반으로 연결된 DBMS 관리도구가 실행됨)
./dbeaver/dbeaver
```

## Driver 설치

- DBeaver는 connection 설정 단계 중, 필요한 드라이버를 인터넷으로 자동 설치

### 오프라인 환경

- Driver 수동 설치 필요
- DBeaver는 java 기반이므로, 접속할 DB에 맞는 `JDBC Driver jar파일`을 고르면 된다.
- DBeaver의 `Database-Driver Manager`에서 새 Driver를 설정하고, jar 파일을 참조하도록 설정
  - Edit Driver 창에 다운로드 출처가 적혀있으므로 참조
  - `/usr/share/java`: Ubuntu에서 Driver를 네이티브 설치 jar 파일 위치
- 새 Driver 설정 후, Connection을 처음부터 생성해주도록 한다.

## 참고

### 23버전 이후 [이슈](https://github.com/dbeaver/dbeaver/issues/19783)

- Ubuntu에서 `libswt-gtk-4-java`가 설치되어있지 않으면 실행 불가
- dbeaver 배포판에 포함되어있지 않음. 별도 설치 필요.

```sh
# 추가 라이브러리 설치
sudo apt install libswt-gtk-4-java

# deb파일 다운로드
apt-get download libswt-gtk-4-java && apt-cache depends -i libswt-gtk-4-java
```

### deb 패키지 설치

- java 17 이상 요구

### CloudBeaver

- dbeaver에서 도커허브로 제공하는 CloudBeaver라는 이미지
- dbeaver와 비슷한 기능의 다른 앱
- DB 관리도구 UI를 웹기반으로 접근할 수 있다.
- DB 관리도구를 원격 서버에 설치한다고 했을 때,,,
  - dbeaver는 ssh 접속 터미널에서 실행시 UI가 따로 실행되는데, CloudBeaver는 따로 웹 접속용 포트도 있어야 할 것으로 보인다.
  - 드라이버도 개별 다운로드가 필요해서 오프라인 환경에서 추가 관리가 필요할 듯

### DBeaver에서 원격 DB를 dump할 때

- 원격 DB를 dump하더라도, 로컬 클라이언트의 dbeaver에서 `mysqldump`가 필요
- `mysqldump`는 mysql server 설치시 포함되어 있음
- dump 설정 창에서 mysql 또는 mysqldump의 bin 파일경로를 지정해야 함

```sh
sudo apt install mysql
which mysql
```
