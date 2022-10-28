# 레포지토리 등록 or 사전 설치 후

# deb파일 추출
mkdir dpkg && cd dpkg
apt-get download {패키지명} && apt-cache depends -i {패키지명} | awk '/Depends:/ {print $2}' | xargs apt-get download
cd ..

# 장점
    # 아무것도 설치할 필요없다. Ubuntu 기본 내장 명령만 사용

# 단점
    # dependency tree가 깊게 들어가는 것은 별도로 다시 확인해줘야 한다.(어지간하면 깊게 안들어감)
    # recursive 처리하는 쉘스크립트를 짤 수 있을 것 같긴한데, 생산성이 안나올듯 싶다.