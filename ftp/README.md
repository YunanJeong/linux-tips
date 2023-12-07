# FTP tips

- 우분투에서 원격 FTP 서버에 접근 방법 기록
- (ubuntu ftp 키워드로 검색시 ftp 서버 구축방법만 나온다... ftp client로 검색필)

## FTP Client

### CLI (우분투 내장)

- ftp
- sftp
- => 실무에선 보통, SFTP 프로토콜만 쓰인다. 폐쇄망이라면 간단히 ftp도 괜찮긴함

### GUI

- gftp

    ```sh
    sudo apt install gftp
    gftp
    ```

- filezilla client
  - 공홈에서 리눅스용 아카이브 파일 다운로드가능

### Python

- ftplib
