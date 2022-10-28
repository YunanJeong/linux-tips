# 레포지토리 등록

# 설치 및 설치파일 백업
sudo apt clean
sudo apt-get install -y {패키지명}
mkdir ./dpkg/
sudo mv /var/cache/apt/archives/*.deb ./dpkg/

# /var/cache/apt/archives/
    # apt install시 deb파일이 임시저장되는 캐시 경로
# $ sudo apt clean: 캐시 경로 비우기

# 장점:
    # dependency tree가 깊게 들어가도 필요한 의존성파일들을 한번에 백업 가능
# 단점:
    # 이미 사전 설치된 dependency는 캐시 경로에 남지 않음
    # 클린 환경에서 설치하는 과정이 필요
