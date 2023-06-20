# 레포지토리 등록 or 사전 설치 후

# deb파일 추출
mkdir dpkg && cd dpkg
sudo apt-get install -y apt-rdepends
apt-rdepends {패키지명} | {awk,grep 등 파싱} | xargs apt-get download
cd ..

# 장점
    # apt-rdepends: 의존관계에 있는 모든 라이브러리를 recursively 보여준다.
    # 내부망에 패키지 설치 후 누락된 dependency들을 일괄적으로 확인하기 좋다.

# 단점
    # apt-rdepend 설치 필요
    # 예외없는 전체 dependency tree라서 불필요한 내용이 많음
    # 최소한의 필수 dependency는 다른 방법으로 확인하는 것이 좋음
