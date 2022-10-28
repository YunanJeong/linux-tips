# 레포지토리 등록 (링크 및 버전 확인 필요)
wget -qO - https://packages.confluent.io/deb/7.2/archive.key | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://packages.confluent.io/deb/7.2 stable main"
sudo add-apt-repository -y "deb https://packages.confluent.io/clients/deb $(lsb_release -cs) main"
sudo apt-get update

# 설치
sudo apt-get install -y confluent-community-2.13

# deb파일 추출
mkdir dpkg_confluent-community-2.13 && cd dpkg_confluent-community-2.13
sudo apt-get install -y apt-rdepend
apt-rdepends confluent-community-2.13 | grep confluent | grep -v Depends | xargs apt-get download
cd ..