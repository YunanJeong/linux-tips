# 레포지토리 등록 (링크 및 버전 확인 필요)
wget -qO - https://packages.confluent.io/deb/7.2/archive.key | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://packages.confluent.io/deb/7.2 stable main"
sudo add-apt-repository -y "deb https://packages.confluent.io/clients/deb $(lsb_release -cs) main"
sudo apt-get update

# 설치
sudo apt-get install -y confluent-schema-registry

# deb파일 추출
mkdir dpkg_schema_registry && cd dpkg_schema_registry
sudo apt-get install -y apt-rdepend
apt-rdepends confluent-schema-registry | grep confluent | grep -v Depends | xargs apt-get download
cd ..
